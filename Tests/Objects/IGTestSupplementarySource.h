/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant 
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIKit.h>

#import <IGListKitStSt/IGListKitStSt.h>

@interface IGTestSupplementarySource : NSObject <IGSTListSupplementaryViewSource>

@property (nonatomic, assign) BOOL dequeueFromNib;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, strong, readwrite) NSArray<NSString *> *supportedElementKinds;

@property (nonatomic, weak) id<IGSTListCollectionContext> collectionContext;

@property (nonatomic, weak) IGSTListSectionController *sectionController;

@end
