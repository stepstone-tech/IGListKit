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

@class IGSTListMoveIndexPath;
@class IGSTListReloadIndexPath;

IGLK_SUBCLASSING_RESTRICTED
@interface IGSTListBatchUpdates : NSObject

@property (nonatomic, strong, readonly) NSMutableIndexSet *sectionReloads;
@property (nonatomic, strong, readonly) NSMutableArray<NSIndexPath *> *itemInserts;
@property (nonatomic, strong, readonly) NSMutableArray<NSIndexPath *> *itemDeletes;
@property (nonatomic, strong, readonly) NSMutableArray<IGSTListReloadIndexPath *> *itemReloads;
@property (nonatomic, strong, readonly) NSMutableArray<IGSTListMoveIndexPath *> *itemMoves;

@property (nonatomic, strong, readonly) NSMutableArray<void (^)()> *itemUpdateBlocks;
@property (nonatomic, strong, readonly) NSMutableArray<void (^)(BOOL)> *itemCompletionBlocks;

- (BOOL)hasChanges;

@end
