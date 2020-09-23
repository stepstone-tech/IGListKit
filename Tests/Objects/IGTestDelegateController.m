/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant 
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "IGSTTestDelegateController.h"

#import "IGSTTestCell.h"
#import "IGSTTestObject.h"

@implementation IGTestDelegateController

- (instancetype)init {
    if (self = [super init]) {
        _willDisplayCellIndexes = [NSCountedSet new];
        _didEndDisplayCellIndexes = [NSCountedSet new];
        _height = 10.0;
        self.workingRangeDelegate = self;
    }
    return self;
}

- (NSInteger)numberOfItems {
    if ([self.item.value isKindOfClass:[NSNumber class]]) {
        return [self.item.value integerValue];
    }
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeMake(self.collectionContext.containerSize.width, self.height);
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    IGTestCell *cell = [self.collectionContext dequeueReusableCellOfClass:IGTestCell.class
                                                          forSectionController:self atIndex:index];
    [[cell label] setText:[NSString stringWithFormat:@"%@", self.item.value]];
    [cell setDelegate:self];
    if (self.cellConfigureBlock) {
        self.cellConfigureBlock(self);
    }
    return cell;
}

- (void)didUpdateToObject:(id)object {
    _updateCount++;
    _item = object;
    if (self.itemUpdateBlock) {
        self.itemUpdateBlock();
    }
}

- (id<IGSTListDisplayDelegate>)displayDelegate {
    return self;
}

- (void)didSelectItemAtIndex:(NSInteger)index {}

#pragma mark - IGSTListDisplayDelegate

- (void)listAdapter:(IGSTListAdapter *)listAdapter willDisplaySectionController:(IGSTListSectionController *)sectionController {
    self.willDisplayCount++;
}

- (void)listAdapter:(IGSTListAdapter *)listAdapter didEndDisplayingSectionController:(IGSTListSectionController *)sectionController {
    self.didEndDisplayCount++;
}

- (void)listAdapter:(IGSTListAdapter *)listAdapter willDisplaySectionController:(IGSTListSectionController *)sectionController
               cell:(UICollectionViewCell *)cell
            atIndex:(NSInteger)index {
    [self.willDisplayCellIndexes addObject:@(index)];
}
- (void)listAdapter:(IGSTListAdapter *)listAdapter didEndDisplayingSectionController:(IGSTListSectionController *)sectionController
               cell:(UICollectionViewCell *)cell
            atIndex:(NSInteger)index {
    [self.didEndDisplayCellIndexes addObject:@(index)];
}

- (void)listAdapter:(IGSTListAdapter *)listAdapter didScrollSectionController:(IGSTListSectionController *)sectionController {}

#pragma mark - IGSTListWorkingRangeDelegate

- (void)listAdapter:(IGSTListAdapter *)listAdapter sectionControllerWillEnterWorkingRange:(IGSTListSectionController *)sectionController {
    __unused UICollectionViewCell *cell = [self.collectionContext cellForItemAtIndex:0 sectionController:self];
}

- (void)listAdapter:(IGSTListAdapter *)listAdapter sectionControllerDidExitWorkingRange:(IGSTListSectionController *)sectionController {}

@end
