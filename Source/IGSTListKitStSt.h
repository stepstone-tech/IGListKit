/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <IGListKitStSt/IGSTListCompatibility.h>

/**
 * Project version number for IGListKit.
 */
FOUNDATION_EXPORT double IGListKitVersionNumber;

/**
 * Project version string for IGListKit.
 */
FOUNDATION_EXPORT const unsigned char IGListKitVersionString[];

#if TARGET_OS_EMBEDDED || TARGET_OS_SIMULATOR

// iOS and tvOS only:

#import <IGListKitStSt/IGSTListAdapter.h>
#import <IGListKitStSt/IGSTListAdapterDataSource.h>
#import <IGListKitStSt/IGSTListAdapterDelegate.h>
#import <IGListKitStSt/IGSTListAdapterUpdater.h>
#import <IGListKitStSt/IGSTListAdapterUpdaterDelegate.h>
#import <IGListKitStSt/IGSTListBatchContext.h>
#import <IGListKitStSt/IGSTListBindable.h>
#import <IGListKitStSt/IGSTListBindingSectionController.h>
#import <IGListKitStSt/IGSTListBindingSectionControllerSelectionDelegate.h>
#import <IGListKitStSt/IGSTListBindingSectionControllerDataSource.h>
#import <IGListKitStSt/IGSTListBindable.h>
#import <IGListKitStSt/IGSTListCollectionContext.h>
#import <IGListKitStSt/IGSTListDisplayDelegate.h>
#import <IGListKitStSt/IGSTListExperiments.h>
#import <IGListKitStSt/IGSTListGenericSectionController.h>
#import <IGListKitStSt/IGSTListSectionController.h>
#import <IGListKitStSt/IGSTListReloadDataUpdater.h>
#import <IGListKitStSt/IGSTListScrollDelegate.h>
#import <IGListKitStSt/IGSTListSingleSectionController.h>
#import <IGListKitStSt/IGSTListStackedSectionController.h>
#import <IGListKitStSt/IGSTListSupplementaryViewSource.h>
#import <IGListKitStSt/IGSTListUpdatingDelegate.h>
#import <IGListKitStSt/IGSTListCollectionViewLayout.h>
#import <IGListKitStSt/IGSTListWorkingRangeDelegate.h>

#endif

// Shared (iOS, tvOS, macOS compatible):

#import <IGListKitStSt/IGSTListAssert.h>
#import <IGListKitStSt/IGSTListBatchUpdateData.h>
#import <IGListKitStSt/IGSTListDiff.h>
#import <IGListKitStSt/IGSTListDiffable.h>
#import <IGListKitStSt/IGSTListExperiments.h>
#import <IGListKitStSt/IGSTListIndexPathResult.h>
#import <IGListKitStSt/IGSTListIndexSetResult.h>
#import <IGListKitStSt/IGSTListMoveIndex.h>
#import <IGListKitStSt/IGSTListMoveIndexPath.h>
#import <IGListKitStSt/NSNumber+IGSTListDiffable.h>
#import <IGListKitStSt/NSString+IGSTListDiffable.h>
