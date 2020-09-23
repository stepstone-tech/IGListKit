/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>

#import <IGListKitStSt/IGSTListMacros.h>

#import <IGListKitStSt/IGSTListSectionController.h>
#import <IGListKitStSt/IGSTListBindingSectionControllerSelectionDelegate.h>
#import <IGListKitStSt/IGSTListBindingSectionControllerDataSource.h>

@protocol IGSTListDiffable;
@protocol IGSTListBindable;

@class IGSTListBindingSectionController;

NS_ASSUME_NONNULL_BEGIN

/**
 This section controller uses a data source to transform its "top level" object into an array of diffable view models.
 It then automatically binds each view model to cells via the `IGSTListBindable` protocol.
 
 Models used with `IGSTListBindingSectionController` should take special care to always return `YES` for identical
 objects. That is, any objects with matching `-diffIdentifier`s should always be equal, that way the section controller
 can create new view models via the data source, create a diff, and update the specific cells that have changed.
 
 In Objective-C, your `-isEqualToDiffableObject:` can simply be:
 ```
 - (BOOL)isEqualToDiffableObject:(id)object {
   return YES;
 }
 ```
 
 In Swift:
 ```
 func isEqual(toDiffableObject object: IGSTListDiffable?) -> Bool {
   return true
 }
 ```
 
 Only when `-diffIdentifier`s match is object equality compared, so you can assume the class is the same, and the
 instance has already been checked.
 */
NS_SWIFT_NAME(ListBindingSectionController)
@interface IGSTListBindingSectionController<__covariant ObjectType : id<IGSTListDiffable>> : IGSTListSectionController

/**
 A data source that transforms a top-level object into view models, and returns cells and sizes for given view models.
 */
@property (nonatomic, weak, nullable) id<IGSTListBindingSectionControllerDataSource> dataSource;

/**
 A delegate that receives selection events from cells in an `IGSTListBindingSectionController` instance.
 */
@property (nonatomic, weak, nullable) id<IGSTListBindingSectionControllerSelectionDelegate> selectionDelegate;

/**
 The object currently assigned to the section controller, if any.
 */
@property (nonatomic, strong, readonly, nullable) ObjectType object;

/**
 The array of view models created from the data source. Values are changed when the top-level object changes or by
 calling `-updateAnimated:completion:` manually.
 */
@property (nonatomic, strong, readonly) NSArray<id<IGSTListDiffable>> *viewModels;

/**
 Tells the section controller to query for new view models, diff the changes, and update its cells.

 @param animated A flag indicating if the transition should be animated or not.
 @param completion An optional completion block executed after updates finish. Parameter is YES if updates were applied.
 */
- (void)updateAnimated:(BOOL)animated completion:(nullable void (^)(BOOL updated))completion;

@end

NS_ASSUME_NONNULL_END
