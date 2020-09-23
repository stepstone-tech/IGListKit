/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <XCTest/XCTest.h>

#import <IGListKitStSt/IGListKitStSt.h>

#import "IGSTListDebugger.h"
#import "IGSTListAdapterUpdaterInternal.h"
#import "IGSTListTestAdapterDataSource.h"
#import "IGSTListMoveIndexInternal.h"
#import "IGSTListMoveIndexPathInternal.h"

@interface IGSTListDebuggerTests : XCTestCase

@end

@implementation IGSTListDebuggerTests

- (void)test_whenSearchingAdapterInstances_thatCorrectCountReturned {
    UIViewController *controller = [UIViewController new];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    IGSTListAdapterUpdater *updater = [IGSTListAdapterUpdater new];
    NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
    updater.applyingUpdateData = [[IGSTListBatchUpdateData alloc] initWithInsertSections:[NSIndexSet indexSetWithIndex:1]
                                                                        deleteSections:[NSIndexSet indexSetWithIndex:2]
                                                                          moveSections:[NSSet setWithObject:[[IGSTListMoveIndex alloc] initWithFrom:3 to:4]]
                                                                      insertIndexPaths:@[path]
                                                                      deleteIndexPaths:@[path]
                                                                        moveIndexPaths:@[[[IGSTListMoveIndexPath alloc] initWithFrom:path to:path]]];
    IGListTestAdapterDataSource *dataSource = [IGListTestAdapterDataSource new];
    dataSource.objects = @[@1, @2, @3];
    IGSTListAdapter *adapter1 = [[IGSTListAdapter alloc] initWithUpdater:[IGSTListAdapterUpdater new] viewController:nil workingRangeSize:0];
    adapter1.collectionView = collectionView;
    adapter1.dataSource = dataSource;
    IGSTListAdapter *adapter2 = [[IGSTListAdapter alloc] initWithUpdater:[IGSTListAdapterUpdater new] viewController:controller workingRangeSize:2];
    adapter2.collectionView = collectionView;
    IGSTListAdapter *adapter3 = [[IGSTListAdapter alloc] initWithUpdater:[IGSTListAdapterUpdater new] viewController:controller workingRangeSize:2];
    adapter3.collectionView = collectionView;

    NSArray *descriptions = [IGSTListDebugger adapterDescriptions];
    XCTAssertEqual(descriptions.count, 4);
}

@end
