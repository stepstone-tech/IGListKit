/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>

#import <IGListKitStSt/IGSTListAdapterDataSource.h>

#import "IGSTTestObject.h"

@interface IGTestSingleStoryboardItemDataSource : NSObject <IGSTListAdapterDataSource>

@property (nonatomic, strong) NSArray <IGTestObject *> *objects;

@end
