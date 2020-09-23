/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "IGSTListWorkingRangeHandler.h"

#import <set>
#import <unordered_set>
#import <vector>

#import <IGListKitStSt/IGSTListAssert.h>
#import <IGListKitStSt/IGSTListAdapter.h>
#import <IGListKitStSt/IGSTListSectionController.h>
#import <IGListKitStSt/IGSTListWorkingRangeDelegate.h>

#import "IGSTListWorkingRangeDelegate.h"

struct _IGSTListWorkingRangeHandlerIndexPath {
    NSInteger section;
    NSInteger row;
    size_t hash;

    bool operator==(const _IGSTListWorkingRangeHandlerIndexPath &other) const {
        return (section == other.section && row == other.row);
    }
};

struct _IGSTListWorkingRangeHandlerSectionControllerWrapper {
    IGSTListSectionController *sectionController;

    bool operator==(const _IGSTListWorkingRangeHandlerSectionControllerWrapper &other) const {
        return (sectionController == other.sectionController);
    }
};

struct _IGSTListWorkingRangeHandlerIndexPathHash {
    size_t operator()(const _IGSTListWorkingRangeHandlerIndexPath& o) const {
        return (size_t)o.hash;
    }
};

struct _IGSTListWorkingRangeHashID {
    size_t operator()(const _IGSTListWorkingRangeHandlerSectionControllerWrapper &o) const {
        return (size_t)[o.sectionController hash];
    }
};

typedef std::unordered_set<_IGSTListWorkingRangeHandlerSectionControllerWrapper, _IGSTListWorkingRangeHashID> _IGSTListWorkingRangeSectionControllerSet;
typedef std::unordered_set<_IGSTListWorkingRangeHandlerIndexPath, _IGSTListWorkingRangeHandlerIndexPathHash> _IGSTListWorkingRangeIndexPathSet;

@interface IGSTListWorkingRangeHandler ()

@property (nonatomic, assign, readonly) NSInteger workingRangeSize;

@end

@implementation IGSTListWorkingRangeHandler {
    _IGSTListWorkingRangeIndexPathSet _visibleSectionIndices;
    _IGSTListWorkingRangeSectionControllerSet _workingRangeSectionControllers;
}

- (instancetype)initWithWorkingRangeSize:(NSInteger)workingRangeSize {
    if (self = [super init]) {
        _workingRangeSize = workingRangeSize;
    }
    return self;
}

- (void)willDisplayItemAtIndexPath:(NSIndexPath *)indexPath
                    forListAdapter:(IGSTListAdapter *)listAdapter {
    IGParameterAssert(indexPath != nil);
    IGParameterAssert(listAdapter != nil);

    _visibleSectionIndices.insert({
        .section = indexPath.section,
        .row = indexPath.row,
        .hash = indexPath.hash
    });

    [self updateWorkingRangesWithListAdapter:listAdapter];
}

- (void)didEndDisplayingItemAtIndexPath:(NSIndexPath *)indexPath
                         forListAdapter:(IGSTListAdapter *)listAdapter {
    IGParameterAssert(indexPath != nil);
    IGParameterAssert(listAdapter != nil);

    _visibleSectionIndices.erase({
        .section = indexPath.section,
        .row = indexPath.row,
        .hash = indexPath.hash
    });

    [self updateWorkingRangesWithListAdapter:listAdapter];
}

#pragma mark - Working Ranges

- (void)updateWorkingRangesWithListAdapter:(IGSTListAdapter *)listAdapter {
    IGAssertMainThread();
    // This method is optimized C++ to improve straight-line speed of these operations. Change at your peril.

    // We use a std::set because it is ordered.
    std::set<NSInteger> visibleSectionSet = std::set<NSInteger>();
    for (const _IGSTListWorkingRangeHandlerIndexPath &indexPath : _visibleSectionIndices) {
        visibleSectionSet.insert(indexPath.section);
    }

    NSInteger start;
    NSInteger end;
    if (visibleSectionSet.size() == 0) {
        // We're now devoid of any visible sections. Bail
        start = 0;
        end = 0;
    } else {
        start = MAX(*visibleSectionSet.begin() - _workingRangeSize, 0);
        end = MIN(*visibleSectionSet.rbegin() + 1 + _workingRangeSize, (NSInteger)listAdapter.objects.count);
    }

    // Build the current set of working range section controllers
    _IGSTListWorkingRangeSectionControllerSet workingRangeSectionControllers (visibleSectionSet.size());
    for (NSInteger idx = start; idx < end; idx++) {
        id item = [listAdapter objectAtSection:idx];
        IGSTListSectionController *sectionController = [listAdapter sectionControllerForObject:item];
        workingRangeSectionControllers.insert({sectionController});
    }

    IGAssert(workingRangeSectionControllers.size() < 1000, @"This algorithm is way too slow with so many objects:%lu", workingRangeSectionControllers.size());

    // Tell any new section controllers that they have entered the working range
    for (const _IGSTListWorkingRangeHandlerSectionControllerWrapper &wrapper : workingRangeSectionControllers) {
        // Check if the item exists in the old working range item array.
        auto it = _workingRangeSectionControllers.find(wrapper);
        if (it == _workingRangeSectionControllers.end()) {
            // The section controller isn't in the existing list, so it's new.
            id <IGSTListWorkingRangeDelegate> workingRangeDelegate = wrapper.sectionController.workingRangeDelegate;
            [workingRangeDelegate listAdapter:listAdapter sectionControllerWillEnterWorkingRange:wrapper.sectionController];
        }
    }

    // Tell any removed section controllers that they have exited the working range
    for (const _IGSTListWorkingRangeHandlerSectionControllerWrapper &wrapper : _workingRangeSectionControllers) {
        // Check if the item exists in the new list of section controllers
        auto it = workingRangeSectionControllers.find(wrapper);
        if (it == workingRangeSectionControllers.end()) {
            // If the item does not exist in the new list, then it's been removed.
            id <IGSTListWorkingRangeDelegate> workingRangeDelegate = wrapper.sectionController.workingRangeDelegate;
            [workingRangeDelegate listAdapter:listAdapter sectionControllerDidExitWorkingRange:wrapper.sectionController];
        }
    }

    _workingRangeSectionControllers = workingRangeSectionControllers;
}

@end
