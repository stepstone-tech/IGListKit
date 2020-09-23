/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant 
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "IGSTTestSingleItemDataSource.h"

#import <IGListKitStSt/IGSTListSingleSectionController.h>

#import "IGSTTestCell.h"

@implementation IGTestSingleItemDataSource

- (NSArray *)objectsForListAdapter:(IGSTListAdapter *)listAdapter {
    return self.objects;
}

- (IGSTListSectionController *)listAdapter:(IGSTListAdapter *)listAdapter sectionControllerForObject:(id)object {
    void (^configureBlock)(id, __kindof UICollectionViewCell *) = ^(IGTestObject *item, IGTestCell *cell) {
        cell.label.text = [item.value description];
    };
    CGSize (^sizeBlock)(id, id<IGSTListCollectionContext>) = ^CGSize(IGTestObject *item, id<IGSTListCollectionContext> collectionContext) {
        return CGSizeMake([collectionContext containerSize].width, 44);
    };
    return [[IGSTListSingleSectionController alloc] initWithCellClass:IGTestCell.class
                                                     configureBlock:configureBlock
                                                          sizeBlock:sizeBlock];
}

- (nullable UIView *)emptyViewForListAdapter:(IGSTListAdapter *)listAdapter {
    return nil;
}

@end
