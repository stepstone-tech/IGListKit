/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <IGListKitStSt/IGSTListAdapter.h>
#import <IGListKitStSt/IGSTListCollectionContext.h>
#import <IGListKitStSt/IGSTListBatchContext.h>

#import "IGSTListAdapterProxy.h"
#import "IGSTListDisplayHandler.h"
#import "IGSTListSectionMap.h"
#import "IGSTListWorkingRangeHandler.h"
#import "IGSTListAdapter+UICollectionView.h"

NS_ASSUME_NONNULL_BEGIN

/// Generate a string representation of a reusable view class when registering with a UICollectionView.
NS_INLINE NSString *IGSTListReusableViewIdentifier(Class viewClass, NSString * _Nullable nibName, NSString * _Nullable kind) {
    return [NSString stringWithFormat:@"%@%@%@", kind ?: @"", nibName ?: @"", NSStringFromClass(viewClass)];
}

@interface IGSTListAdapter ()
<
IGSTListCollectionContext,
IGSTListBatchContext
>
{
    __weak UICollectionView *_collectionView;
    BOOL _isDequeuingCell;
    BOOL _isSendingWorkingRangeDisplayUpdates;
}

@property (nonatomic, strong) id <IGSTListUpdatingDelegate> updater;

@property (nonatomic, strong, readonly) IGSTListSectionMap *sectionMap;
@property (nonatomic, strong, readonly) IGSTListDisplayHandler *displayHandler;
@property (nonatomic, strong, readonly) IGSTListWorkingRangeHandler *workingRangeHandler;

@property (nonatomic, strong, nullable) IGSTListAdapterProxy *delegateProxy;

@property (nonatomic, strong, nullable) UIView *emptyBackgroundView;

/**
 When making object updates inside a batch update block, delete operations must use the section /before/ any moves take
 place. This includes when other objects are deleted or inserted ahead of the section controller making the mutations.
 In order to account for this we must track when the adapter is in the middle of an update block as well as the section
 controller mapping prior to the transition.

 Note that the previous section controller map is destroyed as soon as a transition is finished so there is no dangling
 objects or section controllers.
 */
@property (nonatomic, assign) BOOL isInUpdateBlock;
@property (nonatomic, strong, nullable) IGSTListSectionMap *previousSectionMap;

@property (nonatomic, strong) NSMutableSet<Class> *registeredCellClasses;
@property (nonatomic, strong) NSMutableSet<NSString *> *registeredNibNames;
@property (nonatomic, strong) NSMutableSet<NSString *> *registeredSupplementaryViewIdentifiers;
@property (nonatomic, strong) NSMutableSet<NSString *> *registeredSupplementaryViewNibNames;


- (void)mapView:(__kindof UIView *)view toSectionController:(IGSTListSectionController *)sectionController;
- (nullable IGSTListSectionController *)sectionControllerForView:(__kindof UIView *)view;
- (void)removeMapForView:(__kindof UIView *)view;

- (NSArray *)indexPathsFromSectionController:(IGSTListSectionController *)sectionController
                                     indexes:(NSIndexSet *)indexes
                  usePreviousIfInUpdateBlock:(BOOL)usePreviousIfInUpdateBlock;

- (nullable NSIndexPath *)indexPathForSectionController:(IGSTListSectionController *)controller
                                                  index:(NSInteger)index
                             usePreviousIfInUpdateBlock:(BOOL)usePreviousIfInUpdateBlock;

@end

NS_ASSUME_NONNULL_END
