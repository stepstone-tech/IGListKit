/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "IGSTListBindingSectionController.h"

#import <IGListKitStSt/IGSTListAssert.h>
#import <IGListKitStSt/IGSTListDiffable.h>
#import <IGListKitStSt/IGSTListDiff.h>
#import <IGListKitStSt/IGSTListBindable.h>

typedef NS_ENUM(NSInteger, IGSTListDiffingSectionState) {
    IGSTListDiffingSectionStateIdle = 0,
    IGSTListDiffingSectionStateUpdateQueued,
    IGSTListDiffingSectionStateUpdateApplied
};

@interface IGSTListBindingSectionController()

@property (nonatomic, strong, readwrite) NSArray<id<IGSTListDiffable>> *viewModels;

@property (nonatomic, strong) id object;
@property (nonatomic, assign) IGSTListDiffingSectionState state;

@end

@implementation IGSTListBindingSectionController

#pragma mark - Public API

- (void)updateAnimated:(BOOL)animated completion:(void (^)(BOOL))completion {
    IGAssertMainThread();

    if (self.state != IGSTListDiffingSectionStateIdle) {
        if (completion != nil) {
            completion(NO);
        }
        return;
    }
    self.state = IGSTListDiffingSectionStateUpdateQueued;

    __block IGSTListIndexSetResult *result = nil;
    __block NSArray<id<IGSTListDiffable>> *oldViewModels = nil;

    id<IGSTListCollectionContext> collectionContext = self.collectionContext;
    [self.collectionContext performBatchAnimated:animated updates:^(id<IGSTListBatchContext> batchContext) {
        if (self.state != IGSTListDiffingSectionStateUpdateQueued) {
            return;
        }
        
        oldViewModels = self.viewModels;

        id<IGSTListDiffable> object = self.object;
        IGAssert(object != nil, @"Expected IGSTListBindingSectionController object to be non-nil before updating.");
        
        self.viewModels = [self.dataSource sectionController:self viewModelsForObject:object];
        result = IGSTListDiff(oldViewModels, self.viewModels, IGSTListDiffEquality);
        
        [result.updates enumerateIndexesUsingBlock:^(NSUInteger oldUpdatedIndex, BOOL *stop) {
            id identifier = [oldViewModels[oldUpdatedIndex] diffIdentifier];
            const NSInteger indexAfterUpdate = [result newIndexForIdentifier:identifier];
            if (indexAfterUpdate != NSNotFound) {
                UICollectionViewCell<IGSTListBindable> *cell = [collectionContext cellForItemAtIndex:oldUpdatedIndex
                                                                                 sectionController:self];
                [cell bindViewModel:self.viewModels[indexAfterUpdate]];
            }
        }];
        
        
        [batchContext deleteInSectionController:self atIndexes:result.deletes];
        [batchContext insertInSectionController:self atIndexes:result.inserts];
        
        for (IGSTListMoveIndex *move in result.moves) {
            [batchContext moveInSectionController:self fromIndex:move.from toIndex:move.to];
        }
        
        self.state = IGSTListDiffingSectionStateUpdateApplied;
    } completion:^(BOOL finished) {
        self.state = IGSTListDiffingSectionStateIdle;
        if (completion != nil) {
            completion(YES);
        }
    }];
}

#pragma mark - IGSTListSectionController Overrides

- (NSInteger)numberOfItems {
    return self.viewModels.count;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return [self.dataSource sectionController:self sizeForViewModel:self.viewModels[index] atIndex:index];
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    id<IGSTListDiffable> viewModel = self.viewModels[index];
    UICollectionViewCell<IGSTListBindable> *cell = [self.dataSource sectionController:self cellForViewModel:viewModel atIndex:index];
    [cell bindViewModel:viewModel];
    return cell;
}

- (void)didUpdateToObject:(id)object {
    id oldObject = self.object;
    self.object = object;

    if (oldObject == nil) {
        self.viewModels = [self.dataSource sectionController:self viewModelsForObject:object];
    } else {
        IGAssert([oldObject isEqualToDiffableObject:object],
                 @"Unequal objects %@ and %@ will cause IGSTListBindingSectionController to reload the entire section",
                 oldObject, object);
        [self updateAnimated:YES completion:nil];
    }
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    [self.selectionDelegate sectionController:self didSelectItemAtIndex:index viewModel:self.viewModels[index]];
}

- (void)didDeselectItemAtIndex:(NSInteger)index {
    id<IGSTListBindingSectionControllerSelectionDelegate> selectionDelegate = self.selectionDelegate;
    if ([selectionDelegate respondsToSelector:@selector(sectionController:didDeselectItemAtIndex:viewModel:)]) {
        [selectionDelegate sectionController:self didDeselectItemAtIndex:index viewModel:self.viewModels[index]];
    }
}

@end
