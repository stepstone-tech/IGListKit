/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <XCTest/XCTest.h>

#import <OCMock/OCMock.h>

#import <IGListKitStSt/IGListKitStSt.h>

#import "IGSTListAdapterProxy.h"

@interface IGSTListAdapterProxyTests : XCTestCase

@end

@implementation IGSTListAdapterProxyTests

- (void)test_whenSendingInterceptedMethod_thatAdapterReceivesMethod {
    id mockAdapter = [OCMockObject mockForClass:[IGSTListAdapter class]];
    id mockCollectionViewDelegate = [OCMockObject mockForProtocol:@protocol(UICollectionViewDelegate)];
    IGSTListAdapterProxy *proxy = [[IGSTListAdapterProxy alloc] initWithCollectionViewTarget:mockCollectionViewDelegate scrollViewTarget:nil interceptor:mockAdapter];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    NSIndexPath *indexPath = [NSIndexPath new];

    // method is intercepted and sent to the adapter instead
    [[mockAdapter expect] collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    [[mockCollectionViewDelegate reject] collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    [(id)proxy collectionView:collectionView didSelectItemAtIndexPath:indexPath];

    [mockCollectionViewDelegate verify];
    [mockAdapter verify];
}

- (void)test_whenSendingCollectionViewDelegateMethod_thatCollectionViewDelegateReceivesMethod {
    id mockAdapter = [OCMockObject mockForClass:[IGSTListAdapter class]];
    id mockCollectionViewDelegate = [OCMockObject mockForProtocol:@protocol(UICollectionViewDelegate)];
    IGSTListAdapterProxy *proxy = [[IGSTListAdapterProxy alloc] initWithCollectionViewTarget:mockCollectionViewDelegate scrollViewTarget:nil interceptor:mockAdapter];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    NSIndexPath *indexPath = [NSIndexPath new];

    // method is not intercepted and should be sent to the delegate
    [[mockAdapter reject] collectionView:collectionView shouldShowMenuForItemAtIndexPath:indexPath];
    [[mockCollectionViewDelegate expect] collectionView:collectionView shouldShowMenuForItemAtIndexPath:indexPath];
    [(id)proxy collectionView:collectionView shouldShowMenuForItemAtIndexPath:indexPath];

    [mockCollectionViewDelegate verify];
    [mockAdapter verify];
}

- (void)test_whenSendingScrollViewDelegateMethod_whenNoCollectionViewDelegate_thatScrollViewDelegateReceivesMethod {
    id mockAdapter = [OCMockObject mockForClass:[IGSTListAdapter class]];
    id mockCollectionViewDelegate = [OCMockObject mockForProtocol:@protocol(UICollectionViewDelegate)];
    id mockScrollViewDelegate = [OCMockObject mockForProtocol:@protocol(UIScrollViewDelegate)];
    IGSTListAdapterProxy *proxy = [[IGSTListAdapterProxy alloc] initWithCollectionViewTarget:mockCollectionViewDelegate scrollViewTarget:mockScrollViewDelegate interceptor:mockAdapter];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];

    // method is not intercepted and should be sent to the appropriate delegate
    [[mockAdapter reject] scrollViewDidZoom:collectionView];
    [[mockCollectionViewDelegate reject] scrollViewDidZoom:collectionView];
    [[mockScrollViewDelegate expect] scrollViewDidZoom:collectionView];
    [(id)proxy scrollViewDidZoom:collectionView];

    [mockCollectionViewDelegate verify];
    [mockScrollViewDelegate verify];
    [mockAdapter verify];
}

- (void)test_whenSendingUnimplementedSelector_thatNothingBreaks {
    id mockAdapter = [OCMockObject mockForClass:[IGSTListAdapter class]];
    IGSTListAdapterProxy *proxy = [[IGSTListAdapterProxy alloc] initWithCollectionViewTarget:nil scrollViewTarget:nil interceptor:mockAdapter];

    // this will try to forward a method to nil since there are no targets set
    // verify that this fails silently
    UIScrollView *scrollView = [UIScrollView new];
    [(id)proxy scrollViewDidZoom:scrollView];
}

@end
