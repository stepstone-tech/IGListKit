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

#import "IGSTListTestCase.h"

@class IGTestObject;
@class IGTestDelegateController;

@interface IGTestDelegateDataSource : NSObject <IGListTestCaseDataSource>

@property (nonatomic, strong) NSArray <IGTestObject *> *objects;

@property (nonatomic, copy) void (^cellConfigureBlock)(IGTestDelegateController *);

@end
