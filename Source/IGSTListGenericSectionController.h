/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <IGListKitStSt/IGSTListSectionController.h>

NS_ASSUME_NONNULL_BEGIN

/**
 This class adds a helper layer to `IGSTListSectionController` to automatically store a generic object in
 `didUpdateToObject:`.
 */
NS_SWIFT_NAME(ListGenericSectionController)
@interface IGSTListGenericSectionController<__covariant ObjectType> : IGSTListSectionController

/**
 The object mapped to this section controller. Matches the object provided in
 `[IGSTListAdapterDataSource listAdapter:sectionControllerForObject:]` when this section controller was created and
 returned.

 @note This object is briefly `nil` between initialization and the first call to `didUpdateToObject:`. After that, it is
 safe to assume that this is non-`nil`.
 */
@property (nonatomic, strong, nullable, readonly) ObjectType object;

/**
 Updates the section controller to a new object.

 @param object The object mapped to this section controller.

 @note This `IGSTListSectionController` subclass sets its object in this method, so any overrides **must call super**.
 */
- (void)didUpdateToObject:(id)object NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
