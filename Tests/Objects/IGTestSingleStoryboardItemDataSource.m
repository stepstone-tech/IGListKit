/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "IGSTTestSingleStoryboardItemDataSource.h"

#import <IGListKitStSt/IGSTListSingleSectionController.h>

#import "IGSTTestStoryboardCell.h"

@implementation IGTestSingleStoryboardItemDataSource

- (NSArray<id<IGSTListDiffable>> *)objectsForListAdapter:(IGSTListAdapter *)listAdapter {
    return self.objects;
}

- (IGSTListSectionController *)listAdapter:(IGSTListAdapter *)listAdapter sectionControllerForObject:(id)object
{
    void (^configureBlock)(id, __kindof UICollectionViewCell *) = ^(IGTestObject *item, IGTestStoryboardCell *cell) {
        cell.label.text = [item.value description];
    };
    CGSize (^sizeBlock)(id, id<IGSTListCollectionContext>) = ^CGSize(IGTestObject *item, id<IGSTListCollectionContext> collectionContext) {
        return CGSizeMake([collectionContext containerSize].width, 44);
    };
    return [[IGSTListSingleSectionController alloc] initWithStoryboardCellIdentifier:@"IGTestStoryboardCell"
                                                                    configureBlock:configureBlock
                                                                         sizeBlock:sizeBlock];
}

- (UIView *)emptyViewForListAdapter:(IGSTListAdapter *)listAdapter {
    return nil;
}

@end
