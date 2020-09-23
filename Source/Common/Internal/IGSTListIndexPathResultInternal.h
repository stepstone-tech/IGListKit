/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>

#import <IGListKitStSt/IGSTListIndexPathResult.h>

NS_ASSUME_NONNULL_BEGIN

@interface IGSTListIndexPathResult()

- (instancetype)initWithInserts:(NSArray<NSIndexPath *> *)inserts
                        deletes:(NSArray<NSIndexPath *> *)deletes
                        updates:(NSArray<NSIndexPath *> *)updates
                          moves:(NSArray<IGSTListMoveIndexPath *> *)moves
                oldIndexPathMap:(NSMapTable<id<NSObject>, NSIndexPath *> *)oldIndexPathMap
                newIndexPathMap:(NSMapTable<id<NSObject>, NSIndexPath *> *)newIndexPathMap;

@property (nonatomic, assign, readonly) NSInteger changeCount;

@end

NS_ASSUME_NONNULL_END
