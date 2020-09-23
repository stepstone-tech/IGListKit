/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "IGSTListAdapterUpdater+DebugDescription.h"

#import "IGSTListAdapterUpdaterInternal.h"
#import "IGSTListBatchUpdateData+DebugDescription.h"
#import "IGSTListDebuggingUtilities.h"

#if IGLK_DEBUG_DESCRIPTION_ENABLED
static NSMutableArray *linesFromObjects(NSArray *objects) {
    NSMutableArray *lines = [NSMutableArray new];
    for (id object in objects) {
        [lines addObject:[NSString stringWithFormat:@"Object %p of type %@ with identifier %@",
                          object, NSStringFromClass([object class]), [object diffIdentifier]]];
    }
    return lines;
}
#endif // #if IGLK_DEBUG_DESCRIPTION_ENABLED

@implementation IGSTListAdapterUpdater (DebugDescription)

- (NSArray<NSString *> *)debugDescriptionLines {
    NSMutableArray *debug = [NSMutableArray new];
#if IGLK_DEBUG_DESCRIPTION_ENABLED
    [debug addObject:[NSString stringWithFormat:@"Moves as deletes+inserts: %@", IGSTListDebugBOOL(self.movesAsDeletesInserts)]];
    [debug addObject:[NSString stringWithFormat:@"Allows background reloading: %@", IGSTListDebugBOOL(self.allowsBackgroundReloading)]];
    [debug addObject:[NSString stringWithFormat:@"Has queued reload data: %@", IGSTListDebugBOOL(self.hasQueuedReloadData)]];
    [debug addObject:[NSString stringWithFormat:@"Queued update is animated: %@", IGSTListDebugBOOL(self.queuedUpdateIsAnimated)]];

    NSString *stateString;
    switch (self.state) {
        case IGSTListBatchUpdateStateIdle:
            stateString = @"Idle";
            break;
        case IGSTListBatchUpdateStateQueuedBatchUpdate:
            stateString = @"Queued batch update";
            break;
        case IGSTListBatchUpdateStateExecutedBatchUpdateBlock:
            stateString = @"Executed batch update block";
            break;
        case IGSTListBatchUpdateStateExecutingBatchUpdateBlock:
            stateString = @"Executing batch update block";
            break;
    }
    [debug addObject:[NSString stringWithFormat:@"State: %@", stateString]];

    if (self.applyingUpdateData != nil) {
        [debug addObject:@"Batch update data:"];
        [debug addObjectsFromArray:IGSTListDebugIndentedLines([self.applyingUpdateData debugDescriptionLines])];
    }

    if (self.fromObjects != nil) {
        [debug addObject:@"From objects:"];
        [debug addObjectsFromArray:IGSTListDebugIndentedLines(linesFromObjects(self.fromObjects))];
    }

    if (self.toObjects != nil) {
        [debug addObject:@"To objects:"];
        [debug addObjectsFromArray:IGSTListDebugIndentedLines(linesFromObjects(self.toObjects))];
    }

    if (self.pendingTransitionToObjects != nil) {
        [debug addObject:@"Pending objects:"];
        [debug addObjectsFromArray:IGSTListDebugIndentedLines(linesFromObjects(self.pendingTransitionToObjects))];
    }
#endif // #if IGLK_DEBUG_DESCRIPTION_ENABLED
    return debug;
}

@end
