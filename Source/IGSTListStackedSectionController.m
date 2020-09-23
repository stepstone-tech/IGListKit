/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "IGSTListStackedSectionControllerInternal.h"

#import <objc/runtime.h>

#import <IGListKitStSt/IGSTListAssert.h>
#import <IGListKitStSt/IGSTListSupplementaryViewSource.h>

#import "IGSTListSectionControllerInternal.h"

@interface UICollectionViewCell (IGSTListStackedSectionController)
@end
@implementation UICollectionViewCell (IGSTListStackedSectionController)

static void * kStackedSectionControllerKey = &kStackedSectionControllerKey;

- (void)igst_setStackedSectionController:(id)stackedSectionController {
    objc_setAssociatedObject(self, kStackedSectionControllerKey, stackedSectionController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)igst_stackedSectionController {
    return objc_getAssociatedObject(self, kStackedSectionControllerKey);
}

static void * kStackedSectionControllerIndexKey = &kStackedSectionControllerIndexKey;

- (void)igst_setStackedSectionControllerIndex:(NSInteger)stackedSectionControllerIndex {
    objc_setAssociatedObject(self, kStackedSectionControllerIndexKey, @(stackedSectionControllerIndex), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSInteger)igst_stackedSectionControllerIndex {
    return [objc_getAssociatedObject(self, kStackedSectionControllerIndexKey) integerValue];
}

@end

@implementation IGSTListStackedSectionController

- (instancetype)initWithSectionControllers:(NSArray <IGSTListSectionController *> *)sectionControllers {
    if (self = [super init]) {
        for (IGSTListSectionController *sectionController in sectionControllers) {
            sectionController.collectionContext = self;
            sectionController.viewController = self.viewController;
        }

        _visibleSectionControllers = [NSCountedSet new];
        _sectionControllers = [NSOrderedSet orderedSetWithArray:sectionControllers];

        self.displayDelegate = self;
        self.scrollDelegate = self;
        self.workingRangeDelegate = self;
    }
    return self;
}


#pragma mark - Private API

- (void)reloadData {
    NSMutableArray *sectionControllers = [NSMutableArray new];
    NSMutableArray *offsets = [NSMutableArray new];

    NSInteger numberOfItems = 0;
    for (IGSTListSectionController *sectionController in self.sectionControllers) {
        [offsets addObject:@(numberOfItems)];

        const NSInteger items = [sectionController numberOfItems];
        for (NSInteger i = 0; i < items; i++) {
            [sectionControllers addObject:sectionController];
        }

        numberOfItems += items;
    }

    self.sectionControllerOffsets = offsets;
    self.flattenedNumberOfItems = numberOfItems;
    self.sectionControllersForItems = sectionControllers;

    IGAssert(self.sectionControllerOffsets.count == self.sectionControllers.count, @"Not enough offsets for section controllers");
    IGAssert(self.sectionControllersForItems.count == self.flattenedNumberOfItems, @"Controller map does not equal total number of items");
}

- (IGSTListSectionController *)sectionControllerForObjectIndex:(NSInteger)itemIndex {
    return self.sectionControllersForItems[itemIndex];
}

- (NSInteger)offsetForSectionController:(IGSTListSectionController *)sectionController {
    const NSInteger index = [self.sectionControllers indexOfObject:sectionController];
    IGAssert(index != NSNotFound, @"Querying offset for an undocumented section controller");
    return [self.sectionControllerOffsets[index] integerValue];
}

- (NSInteger)localIndexForSectionController:(IGSTListSectionController *)sectionController index:(NSInteger)index {
    const NSInteger offset = [self offsetForSectionController:sectionController];
    IGAssert(offset <= index, @"Section controller offset must be less than or equal to the item index");
    return index - offset;
}

- (NSInteger)relativeIndexForSectionController:(IGSTListSectionController *)sectionController fromLocalIndex:(NSInteger)index {
    const NSInteger offset = [self offsetForSectionController:sectionController];
    return index + offset;
}

- (NSIndexSet *)itemIndexesForSectionController:(IGSTListSectionController *)sectionController indexes:(NSIndexSet *)indexes {
    const NSInteger offset = [self offsetForSectionController:sectionController];
    NSMutableIndexSet *itemIndexes = [NSMutableIndexSet new];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        [itemIndexes addIndex:(idx + offset)];
    }];
    return itemIndexes;
}

- (id<IGSTListSupplementaryViewSource>)supplementaryViewSource {
    for (IGSTListSectionController *sectionController in self.sectionControllers) {
        id<IGSTListSupplementaryViewSource> supplementaryViewSource = sectionController.supplementaryViewSource;
        if (supplementaryViewSource != nil) {
            return supplementaryViewSource;
        }
    }
    return nil;
}

#pragma mark - IGSTListSectionController Overrides

- (NSInteger)numberOfItems {
    return self.flattenedNumberOfItems;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    IGSTListSectionController *sectionController = [self sectionControllerForObjectIndex:index];
    const NSInteger localIndex = [self localIndexForSectionController:sectionController index:index];
    return [sectionController sizeForItemAtIndex:localIndex];
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    IGSTListSectionController *sectionController = [self sectionControllerForObjectIndex:index];
    const NSInteger localIndex = [self localIndexForSectionController:sectionController index:index];
    return [sectionController cellForItemAtIndex:localIndex];
}

- (void)didUpdateToObject:(id)object {
    for (IGSTListSectionController *sectionController in self.sectionControllers) {
        sectionController.section = self.section;
        [sectionController didUpdateToObject:object];
    }
    [self reloadData];
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    IGSTListSectionController *sectionController = [self sectionControllerForObjectIndex:index];
    const NSInteger localIndex = [self localIndexForSectionController:sectionController index:index];
    [sectionController didSelectItemAtIndex:localIndex];
}

- (void)didDeselectItemAtIndex:(NSInteger)index {
    IGSTListSectionController *sectionController = [self sectionControllerForObjectIndex:index];
    const NSInteger localIndex = [self localIndexForSectionController:sectionController index:index];
    [sectionController didDeselectItemAtIndex:localIndex];
}

#pragma mark - IGSTListCollectionContext

- (CGSize)containerSize {
    return [self.collectionContext containerSize];
}

- (UIEdgeInsets)containerInset {
    return [self.collectionContext containerInset];
}

- (CGSize)insetContainerSize {
    return [self.collectionContext insetContainerSize];
}

- (CGSize)containerSizeForSectionController:(IGSTListSectionController *)sectionController {
    const UIEdgeInsets inset = sectionController.inset;
    return CGSizeMake(self.containerSize.width - inset.left - inset.right,
                      self.containerSize.height - inset.top - inset.bottom);
}

- (NSInteger)indexForCell:(UICollectionViewCell *)cell sectionController:(IGSTListSectionController *)sectionController {
    const NSInteger index = [self.collectionContext indexForCell:cell sectionController:self];
    return [self localIndexForSectionController:sectionController index:index];
}

- (UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index sectionController:(IGSTListSectionController *)sectionController {
    return [self.collectionContext cellForItemAtIndex: [self relativeIndexForSectionController:sectionController fromLocalIndex:index] sectionController:self];
}

- (NSArray<UICollectionViewCell *> *)visibleCellsForSectionController:(IGSTListSectionController *)sectionController {
    NSMutableArray *cells = [NSMutableArray new];
    id<IGSTListCollectionContext> collectionContext = self.collectionContext;
    NSArray *visibleCells = [collectionContext visibleCellsForSectionController:self];
    for (UICollectionViewCell *cell in visibleCells) {
        const NSInteger index = [collectionContext indexForCell:cell sectionController:self];
        if (self.sectionControllersForItems[index] == sectionController) {
            [cells addObject:cell];
        }
    }
    return cells;
}

- (NSArray<NSIndexPath *> *)visibleIndexPathsForSectionController:(IGSTListSectionController *)sectionController {
    NSMutableArray *paths = [NSMutableArray new];
    id<IGSTListCollectionContext> collectionContext = self.collectionContext;
    NSArray *visiblePaths = [collectionContext visibleIndexPathsForSectionController:self];
    for (NSIndexPath *path in visiblePaths) {
        if (self.sectionControllersForItems[path.item] == sectionController) {
            [paths addObject:path];
        }
    }
    return paths;
}

- (void)deselectItemAtIndex:(NSInteger)index sectionController:(IGSTListSectionController *)sectionController animated:(BOOL)animated {
    const NSInteger offsetIndex = [self relativeIndexForSectionController:sectionController fromLocalIndex:index];
    [self.collectionContext deselectItemAtIndex:offsetIndex sectionController:self animated:animated];
}

- (void)selectItemAtIndex:(NSInteger)index
        sectionController:(IGSTListSectionController *)sectionController
                 animated:(BOOL)animated
           scrollPosition:(UICollectionViewScrollPosition)scrollPosition {
    const NSInteger offsetIndex = [self relativeIndexForSectionController:sectionController fromLocalIndex:index];
    [self.collectionContext selectItemAtIndex:offsetIndex sectionController:self animated:animated scrollPosition:scrollPosition];
}

- (UICollectionViewCell *)dequeueReusableCellOfClass:(Class)cellClass
                                forSectionController:(IGSTListSectionController *)sectionController
                                             atIndex:(NSInteger)index {
    const NSInteger offsetIndex = [self relativeIndexForSectionController:sectionController fromLocalIndex:index];
    return (UICollectionViewCell *_Nonnull)[self.collectionContext dequeueReusableCellOfClass:cellClass
                                                                         forSectionController:self
                                                                                      atIndex:offsetIndex];
}

- (UICollectionViewCell *)dequeueReusableCellWithNibName:(NSString *)nibName
                                                  bundle:(NSBundle *)bundle
                                    forSectionController:(IGSTListSectionController *)sectionController
                                                 atIndex:(NSInteger)index {
    const NSInteger offsetIndex = [self relativeIndexForSectionController:sectionController fromLocalIndex:index];
    return (UICollectionViewCell *_Nonnull)[self.collectionContext dequeueReusableCellWithNibName:nibName
                                                                                           bundle:bundle
                                                                             forSectionController:self
                                                                                          atIndex:offsetIndex];
}

- (UICollectionViewCell *)dequeueReusableCellFromStoryboardWithIdentifier:(NSString *)identifier
                                                     forSectionController:(IGSTListSectionController *)sectionController
                                                                  atIndex:(NSInteger)index {
    const NSInteger offsetIndex = [self relativeIndexForSectionController:sectionController fromLocalIndex:index];
    return (UICollectionViewCell *_Nonnull)[self.collectionContext dequeueReusableCellFromStoryboardWithIdentifier:identifier
                                                                                              forSectionController:self
                                                                                                           atIndex:offsetIndex];
}

- (UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                                                forSectionController:(IGSTListSectionController *)sectionController
                                                               class:(Class)viewClass
                                                             atIndex:(NSInteger)index {
    const NSInteger offsetIndex = [self relativeIndexForSectionController:sectionController fromLocalIndex:index];
    return (UICollectionViewCell *_Nonnull)[self.collectionContext dequeueReusableSupplementaryViewOfKind:elementKind
                                                                                     forSectionController:self
                                                                                                    class:viewClass
                                                                                                  atIndex:offsetIndex];
}

- (UICollectionReusableView *)dequeueReusableSupplementaryViewFromStoryboardOfKind:(NSString *)elementKind
                                                                    withIdentifier:(NSString *)identifier
                                                              forSectionController:(IGSTListSectionController *)sectionController
                                                                           atIndex:(NSInteger)index {
    const NSInteger offsetIndex = [self relativeIndexForSectionController:sectionController fromLocalIndex:index];
    return (UICollectionViewCell *_Nonnull)[self.collectionContext dequeueReusableSupplementaryViewFromStoryboardOfKind:elementKind
                                                                                                         withIdentifier:identifier
                                                                                                   forSectionController:self
                                                                                                                atIndex:offsetIndex];
}

- (UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                                                forSectionController:(IGSTListSectionController *)sectionController
                                                             nibName:(NSString *)nibName
                                                              bundle:(NSBundle *)bundle
                                                             atIndex:(NSInteger)index {
    const NSInteger offsetIndex = [self relativeIndexForSectionController:sectionController fromLocalIndex:index];
    return (UICollectionViewCell *_Nonnull)[self.collectionContext dequeueReusableSupplementaryViewOfKind:elementKind
                                                                                     forSectionController:self
                                                                                                  nibName:nibName
                                                                                                   bundle:bundle
                                                                                                  atIndex:offsetIndex];
}

- (void)performBatchAnimated:(BOOL)animated updates:(void (^)(id<IGSTListBatchContext>))updates completion:(void (^)(BOOL))completion {
    __weak __typeof__(self) weakSelf = self;
    [self.collectionContext performBatchAnimated:animated updates:^ (id<IGSTListBatchContext> batchContext) {
        weakSelf.forwardingBatchContext = batchContext;
        updates(weakSelf);
        weakSelf.forwardingBatchContext = nil;
    } completion:^(BOOL finished) {
        [weakSelf reloadData];
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)scrollToSectionController:(IGSTListSectionController *)sectionController
                          atIndex:(NSInteger)index
                   scrollPosition:(UICollectionViewScrollPosition)scrollPosition
                         animated:(BOOL)animated {
    const NSInteger offsetIndex = [self relativeIndexForSectionController:sectionController fromLocalIndex:index];
    [self.collectionContext scrollToSectionController:self
                                              atIndex:offsetIndex
                                       scrollPosition:scrollPosition
                                             animated:animated];
}

- (void)invalidateLayoutForSectionController:(IGSTListSectionController *)sectionController completion:(void (^)(BOOL))completion {
    [self.collectionContext invalidateLayoutForSectionController:self completion:completion];
}

#pragma mark - IGSTListBatchContext

- (void)reloadInSectionController:(IGSTListSectionController *)sectionController atIndexes:(NSIndexSet *)indexes {
    NSIndexSet *itemIndexes = [self itemIndexesForSectionController:sectionController indexes:indexes];
    [self.forwardingBatchContext reloadInSectionController:self atIndexes:itemIndexes];
}

- (void)insertInSectionController:(IGSTListSectionController *)sectionController atIndexes:(NSIndexSet *)indexes {
    [self reloadData];
    NSIndexSet *itemIndexes = [self itemIndexesForSectionController:sectionController indexes:indexes];
    [self.forwardingBatchContext insertInSectionController:self atIndexes:itemIndexes];
}

- (void)deleteInSectionController:(IGSTListSectionController *)sectionController atIndexes:(NSIndexSet *)indexes {
    [self reloadData];
    NSIndexSet *itemIndexes = [self itemIndexesForSectionController:sectionController indexes:indexes];
    [self.forwardingBatchContext deleteInSectionController:self atIndexes:itemIndexes];
}

- (void)moveInSectionController:(IGSTListSectionController *)sectionController fromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    [self reloadData];
    const NSInteger fromRelativeIndex = [self relativeIndexForSectionController:sectionController fromLocalIndex:fromIndex];
    const NSInteger toRelativeIndex = [self relativeIndexForSectionController:sectionController fromLocalIndex:toIndex];
    [self.forwardingBatchContext moveInSectionController:self fromIndex:fromRelativeIndex toIndex:toRelativeIndex];
}

- (void)reloadSectionController:(IGSTListSectionController *)sectionController {
    [self reloadData];
    [self.forwardingBatchContext reloadSectionController:self];
}

#pragma mark - IGSTListDisplayDelegate

- (void)listAdapter:(IGSTListAdapter *)listAdapter willDisplaySectionController:(IGSTListSectionController *)sectionController cell:(UICollectionViewCell *)cell atIndex:(NSInteger)index {
    IGSTListSectionController *childSectionController = [self sectionControllerForObjectIndex:index];
    const NSInteger localIndex = [self localIndexForSectionController:childSectionController index:index];

    // update the assoc objects for use in didEndDisplay
    [cell igst_setStackedSectionController:childSectionController];
    [cell igst_setStackedSectionControllerIndex:localIndex];

    NSCountedSet *visibleSectionControllers = self.visibleSectionControllers;
    id<IGSTListDisplayDelegate> displayDelegate = [childSectionController displayDelegate];

    if ([visibleSectionControllers countForObject:childSectionController] == 0) {
        [displayDelegate listAdapter:listAdapter willDisplaySectionController:childSectionController];
    }
    [displayDelegate listAdapter:listAdapter willDisplaySectionController:childSectionController cell:cell atIndex:localIndex];

    [visibleSectionControllers addObject:childSectionController];
}

- (void)listAdapter:(IGSTListAdapter *)listAdapter didEndDisplayingSectionController:(IGSTListSectionController *)sectionController cell:(UICollectionViewCell *)cell atIndex:(NSInteger)index {
    const NSInteger localIndex = [cell igst_stackedSectionControllerIndex];
    IGSTListSectionController *childSectionController = [cell igst_stackedSectionController];

    NSCountedSet *visibleSectionControllers = self.visibleSectionControllers;
    id<IGSTListDisplayDelegate> displayDelegate = [childSectionController displayDelegate];

    [displayDelegate listAdapter:listAdapter didEndDisplayingSectionController:childSectionController cell:cell atIndex:localIndex];

    [visibleSectionControllers removeObject:childSectionController];
    if ([visibleSectionControllers countForObject:childSectionController] == 0) {
        [displayDelegate listAdapter:listAdapter didEndDisplayingSectionController:childSectionController];
    }
}

- (void)listAdapter:(IGSTListAdapter *)listAdapter willDisplaySectionController:(IGSTListSectionController *)sectionController {}
- (void)listAdapter:(IGSTListAdapter *)listAdapter didEndDisplayingSectionController:(IGSTListSectionController *)sectionController {}

#pragma mark - IGSTListScrollDelegate

- (void)listAdapter:(IGSTListAdapter *)listAdapter didScrollSectionController:(IGSTListSectionController *)sectionController {
    for (IGSTListSectionController *childSectionController in self.sectionControllers) {
        [[childSectionController scrollDelegate] listAdapter:listAdapter didScrollSectionController:childSectionController];
    }
}

- (void)listAdapter:(IGSTListAdapter *)listAdapter willBeginDraggingSectionController:(IGSTListSectionController *)sectionController {
    for (IGSTListSectionController *childSectionController in self.sectionControllers) {
        [[childSectionController scrollDelegate] listAdapter:listAdapter willBeginDraggingSectionController:childSectionController];
    }
}

- (void)listAdapter:(IGSTListAdapter *)listAdapter didEndDraggingSectionController:(IGSTListSectionController *)sectionController willDecelerate:(BOOL)decelerate {
    for (IGSTListSectionController *childSectionController in self.sectionControllers) {
        [[childSectionController scrollDelegate] listAdapter:listAdapter didEndDraggingSectionController:childSectionController willDecelerate:decelerate];
    }
}

- (void)listAdapter:(IGSTListAdapter *)listAdapter didEndDeceleratingSectionController:(IGSTListSectionController *)sectionController {
    for (IGSTListSectionController *childSectionController in self.sectionControllers) {
        id<IGSTListScrollDelegate> scrollDelegate = [childSectionController scrollDelegate];
        if ([scrollDelegate respondsToSelector:@selector(listAdapter:didEndDeceleratingSectionController:)]) {
            [scrollDelegate listAdapter:listAdapter didEndDeceleratingSectionController:childSectionController];
        }
    }
}

#pragma mark - IGSTListWorkingRangeDelegate

- (void)listAdapter:(IGSTListAdapter *)listAdapter sectionControllerWillEnterWorkingRange:(IGSTListSectionController *)sectionController {
    for (IGSTListSectionController *childSectionController in self.sectionControllers) {
        [[childSectionController workingRangeDelegate] listAdapter:listAdapter sectionControllerWillEnterWorkingRange:childSectionController];
    }
}

- (void)listAdapter:(IGSTListAdapter *)listAdapter sectionControllerDidExitWorkingRange:(IGSTListSectionController *)sectionController {
    for (IGSTListSectionController *childSectionController in self.sectionControllers) {
        [[childSectionController workingRangeDelegate] listAdapter:listAdapter sectionControllerDidExitWorkingRange:childSectionController];
    }
}

@end
