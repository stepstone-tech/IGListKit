/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>

#import <IGListKitStSt/IGSTListDiffable.h>
#import <IGListKitStSt/IGSTListIndexPathResult.h>
#import <IGListKitStSt/IGSTListIndexSetResult.h>

NS_ASSUME_NONNULL_BEGIN

/**
 An option for how to do comparisons between similar objects.
 */
NS_SWIFT_NAME(ListDiffOption)
typedef NS_ENUM(NSInteger, IGSTListDiffOption) {
    /**
     Compare objects using pointer personality.
     */
    IGSTListDiffPointerPersonality,
    /**
     Compare objects using `-[IGSTListDiffable isEqualToDiffableObject:]`.
     */
    IGSTListDiffEquality
};

/**
 Creates a diff using indexes between two collections.

 @param oldArray The old objects to diff against.
 @param newArray The new objects.
 @param option An option on how to compare objects.

 @return A result object containing affected indexes.
 */
NS_SWIFT_NAME(ListDiff(oldArray:newArray:option:))
FOUNDATION_EXTERN  IGSTListIndexSetResult *IGSTListDiff(NSArray<id<IGSTListDiffable>> *_Nullable oldArray,
                                                   NSArray<id<IGSTListDiffable>> *_Nullable newArray,
                                                   IGSTListDiffOption option);

/**
 Creates a diff using index paths between two collections.

 @param fromSection The old section.
 @param toSection The new section.
 @param oldArray The old objects to diff against.
 @param newArray The new objects.
 @param option An option on how to compare objects.

 @return A result object containing affected indexes.
 */
NS_SWIFT_NAME(ListDiffPaths(fromSection:toSection:oldArray:newArray:option:))
FOUNDATION_EXTERN IGSTListIndexPathResult *IGSTListDiffPaths(NSInteger fromSection,
                                                         NSInteger toSection,
                                                         NSArray<id<IGSTListDiffable>> *_Nullable oldArray,
                                                         NSArray<id<IGSTListDiffable>> *_Nullable newArray,
                                                         IGSTListDiffOption option);

NS_ASSUME_NONNULL_END
