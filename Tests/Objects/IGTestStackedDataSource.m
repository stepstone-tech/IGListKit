/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant 
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "IGSTTestStackedDataSource.h"

#import <IGListKitStSt/IGSTListStackedSectionController.h>

#import "IGSTTestCell.h"
#import "IGSTListTestSection.h"
#import "IGSTListTestContainerSizeSection.h"

@implementation IGTestStackedDataSource

- (NSArray *)objectsForListAdapter:(IGSTListAdapter *)listAdapter {
    return self.objects;
}

- (IGSTListSectionController *)listAdapter:(IGSTListAdapter *)listAdapter sectionControllerForObject:(id)object {
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (id value in [(IGTestObject *)object value]) {
        id controller;
        // use a standard IGListTestSection
        if ([value isKindOfClass:[NSNumber class]]) {
            if ([(NSNumber*)value isEqual: @42]) {
                IGListTestContainerSizeSection *section = [[IGListTestContainerSizeSection alloc] init];
                section.items = [value integerValue];
                controller = section;
            } else {
                IGListTestSection *section = [[IGListTestSection alloc] init];
                section.items = [value integerValue];
                controller = section;
            }
        } else if ([value isKindOfClass:[NSString class]]) {
            void (^configureBlock)(id, __kindof UICollectionViewCell *) = ^(id obj, IGTestCell *cell) {
                // capturing the value in block scope so we use the CHILD OBJECT of the stack
                // otherwise the block uses the IGTestObject in the block param
                cell.label.text = value;
            };
            CGSize (^sizeBlock)(id, id<IGSTListCollectionContext>) = ^CGSize(IGTestObject *item, id<IGSTListCollectionContext> collectionContext) {
                return CGSizeMake([collectionContext containerSize].width, 44);
            };

            // use either nibs or storyboards with NSString depending on the string value
            if ([value isEqualToString:@"nib"]) {
                controller = [[IGSTListSingleSectionController alloc] initWithNibName:@"IGTestNibCell"
                                                                       bundle:[NSBundle bundleForClass:self.class]
                                                               configureBlock:configureBlock
                                                                    sizeBlock:sizeBlock];
            } else {
                controller = [[IGSTListSingleSectionController alloc] initWithStoryboardCellIdentifier:@"IGTestStoryboardCell"
                                                                                configureBlock:configureBlock
                                                                                     sizeBlock:sizeBlock];
            }
        }
        [controllers addObject:controller];
    }
    return [[IGSTListStackedSectionController alloc] initWithSectionControllers:controllers];
}

- (nullable UIView *)emptyViewForListAdapter:(IGSTListAdapter *)listAdapter {
    return nil;
}

@end
