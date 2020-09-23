/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "IGSTListSectionController.h"

FOUNDATION_EXTERN void IGSTListSectionControllerPushThread(UIViewController *viewController, id<IGSTListCollectionContext> collectionContext);

FOUNDATION_EXTERN void IGSTListSectionControllerPopThread(void);

@interface IGSTListSectionController()

@property (nonatomic, weak, readwrite) id<IGSTListCollectionContext> collectionContext;

@property (nonatomic, weak, readwrite) UIViewController *viewController;

@property (nonatomic, assign, readwrite) NSInteger section;

@property (nonatomic, assign, readwrite) BOOL isFirstSection;

@property (nonatomic, assign, readwrite) BOOL isLastSection;

@end
