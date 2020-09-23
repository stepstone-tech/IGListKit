/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "IGSTListTestAdapterStoryboardDataSource.h"

#import <IGListKitStSt/IGSTListAdapter.h>

#import "IGSTListTestStoryboardSection.h"

@implementation IGListTestAdapterStoryboardDataSource

- (NSArray *)objectsForListAdapter:(IGSTListAdapter *)listAdapter {
    return self.objects;
}

- (IGSTListSectionController *)listAdapter:(IGSTListAdapter *)listAdapter sectionControllerForObject:(id)object {
    IGListTestStoryboardSection *list = [[IGListTestStoryboardSection alloc] init];
    return list;
}

- (nullable UIView *)emptyViewForListAdapter:(IGSTListAdapter *)listAdapter {
    return self.backgroundView;
}

@end
