/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "IGSTTestDiffingDataSource.h"

#import "IGSTTestDiffingObject.h"
#import "IGSTTestDiffingSectionController.h"

@implementation IGTestDiffingDataSource

#pragma mark - IGSTListAdapterDataSource

- (NSArray<id<IGSTListDiffable>> *)objectsForListAdapter:(IGSTListAdapter *)listAdapter {
    return self.objects;
}

- (IGSTListSectionController *)listAdapter:(IGSTListAdapter *)listAdapter sectionControllerForObject:(id)object {
    return [IGTestDiffingSectionController new];
}

- (UIView *)emptyViewForListAdapter:(IGSTListAdapter *)listAdapter { return nil; }

@end
