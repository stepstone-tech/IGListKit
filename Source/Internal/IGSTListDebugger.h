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

@class IGSTListAdapter;

IGLK_SUBCLASSING_RESTRICTED
@interface IGSTListDebugger : NSObject

+ (void)trackAdapter:(IGSTListAdapter *)adapter;

+ (NSArray<NSString *> *)adapterDescriptions;

+ (NSString *)dump;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end
