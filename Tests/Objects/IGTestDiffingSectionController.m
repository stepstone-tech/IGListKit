/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "IGSTTestDiffingSectionController.h"

#import "IGSTTestDiffingObject.h"
#import "IGSTTestStringBindableCell.h"
#import "IGSTTestNumberBindableCell.h"
#import "IGSTTestObject.h"
#import "IGSTTestCell.h"

@implementation IGTestDiffingSectionController

- (instancetype)init {
    if (self = [super init]) {
        self.dataSource = self;
        self.selectionDelegate = self;
    }
    return self;
}

#pragma mark - IGSTListBindingSectionControllerDataSource

- (NSArray<id<IGSTListDiffable>> *)sectionController:(IGSTListBindingSectionController *)sectionController viewModelsForObject:(id)object {
    return [(IGTestDiffingObject *)object objects];
}

- (UICollectionViewCell<IGSTListBindable> *)sectionController:(IGSTListBindingSectionController *)sectionController cellForViewModel:(id)viewModel atIndex:(NSInteger)index {
    Class cellClass;
    if ([viewModel isKindOfClass:[NSString class]]) {
        cellClass = [IGTestStringBindableCell class];
    } else if ([viewModel isKindOfClass:[NSNumber class]]) {
        cellClass = [IGTestNumberBindableCell class];
    } else {
        cellClass = [IGTestCell class];
    }
    id cell = [self.collectionContext dequeueReusableCellOfClass:cellClass forSectionController:self atIndex:index];
    return cell;
}

- (CGSize)sectionController:(IGSTListBindingSectionController *)sectionController sizeForViewModel:(id)viewModel atIndex:(NSInteger)index {
    const BOOL isString = [viewModel isKindOfClass:[NSString class]];
    return CGSizeMake([self.collectionContext containerSize].width, isString ? 55 : 30);
}

#pragma mark - IGSTListBindingSectionControllerSelectionDelegate

- (void)sectionController:(IGSTListBindingSectionController *)sectionController didSelectItemAtIndex:(NSInteger)index viewModel:(id)viewModel {
    self.selectedViewModel = viewModel;
}

- (void)sectionController:(IGSTListBindingSectionController *)sectionController didDeselectItemAtIndex:(NSInteger)index viewModel:(id)viewModel {
    self.deselectedViewModel = viewModel;
}

@end
