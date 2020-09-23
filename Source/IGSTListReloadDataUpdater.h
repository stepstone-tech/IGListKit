/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIKit.h>

#import <IGListKitStSt/IGSTListMacros.h>
#import <IGListKitStSt/IGSTListUpdatingDelegate.h>

NS_ASSUME_NONNULL_BEGIN

/**
 An `IGSTListReloadDataUpdater` is a concrete type that conforms to `IGSTListUpdatingDelegate`.
 It is an out-of-box updater for `IGSTListAdapter` objects to use.

 @note This updater performs simple, synchronous updates using `-[UICollectionView reloadData]`.
 */
IGLK_SUBCLASSING_RESTRICTED
NS_SWIFT_NAME(ListReloadDataUpdater)
@interface IGSTListReloadDataUpdater : NSObject <IGSTListUpdatingDelegate>

@end

NS_ASSUME_NONNULL_END
