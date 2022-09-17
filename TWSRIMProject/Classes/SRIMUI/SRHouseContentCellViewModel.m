//
//  SRHouseContentCellViewModel.m
//  addcnos
//
//  Created by addcnos on 2019/9/23.
//  Copyright © 2019 addcnos All rights reserved.
//

#import "SRHouseContentCellViewModel.h"

@implementation SRHouseContentCellViewModel

- (instancetype)initWithChatModel:(SRChatModel *)chatModel {
    self = [super init];
    if (self) {
        self.chatModel = chatModel;
    }
    return self;
}

- (CGFloat )cellHeight {
    return 245;
}

@end
