/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "IGSTListSectionControllerInternal.h"

#import <IGListKitStSt/IGSTListMacros.h>
#import <IGListKitStSt/IGSTListAssert.h>

static NSString * const kIGSTListSectionControllerThreadKey = @"kIGSTListSectionControllerThreadKey";

@interface IGSTListSectionControllerThreadContext : NSObject
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, weak) id<IGSTListCollectionContext> collectionContext;
@end
@implementation IGSTListSectionControllerThreadContext
@end

static NSMutableArray<IGSTListSectionControllerThreadContext *> *threadContextStack(void) {
    IGAssertMainThread();
    NSMutableDictionary *threadDictionary = [[NSThread currentThread] threadDictionary];
    NSMutableArray *stack = threadDictionary[kIGSTListSectionControllerThreadKey];
    if (stack == nil) {
        stack = [NSMutableArray new];
        threadDictionary[kIGSTListSectionControllerThreadKey] = stack;
    }
    return stack;
}

void IGSTListSectionControllerPushThread(UIViewController *viewController, id<IGSTListCollectionContext> collectionContext) {
    IGSTListSectionControllerThreadContext *context = [IGSTListSectionControllerThreadContext new];
    context.viewController = viewController;
    context.collectionContext = collectionContext;

    [threadContextStack() addObject:context];
}

void IGSTListSectionControllerPopThread(void) {
    NSMutableArray *stack = threadContextStack();
    IGAssert(stack.count > 0, @"IGListSectionController thread stack is empty");
    [stack removeLastObject];
}

@implementation IGSTListSectionController

- (instancetype)init {
    if (self = [super init]) {
        IGSTListSectionControllerThreadContext *context = [threadContextStack() lastObject];
        _viewController = context.viewController;
        _collectionContext = context.collectionContext;

        if (_collectionContext == nil) {
            IGLKLog(@"Warning: Creating %@ outside of -[IGSTListAdapterDataSource listAdapter:sectionControllerForObject:]. Collection context and view controller will be set later.",
                    NSStringFromClass([self class]));
        }

        _minimumInteritemSpacing = 0.0;
        _minimumLineSpacing = 0.0;
        _inset = UIEdgeInsetsZero;
        _section = NSNotFound;
    }
    return self;
}

- (NSInteger)numberOfItems {
    return 1;
}

- (CGSize)sizeForItemAtIndex:(NSInteger)index {
    return CGSizeZero;
}

- (__kindof UICollectionViewCell *)cellForItemAtIndex:(NSInteger)index {
    IGFailAssert(@"Section controller %@ must override %s:", self, __PRETTY_FUNCTION__);
    return nil;
}

- (void)didUpdateToObject:(id)object {}

- (void)didSelectItemAtIndex:(NSInteger)index {}

- (void)didDeselectItemAtIndex:(NSInteger)index {}

@end
