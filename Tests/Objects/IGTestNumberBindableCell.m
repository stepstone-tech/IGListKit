/**
 * Copyright (c) 2016-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "IGSTTestNumberBindableCell.h"

@implementation IGTestNumberBindableCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _textField = [UITextField new];
    }
    return self;
}

#pragma mark - IGSTListBindable

- (void)bindViewModel:(id)viewModel {
    self.textField.text = [viewModel description];
}

@end
