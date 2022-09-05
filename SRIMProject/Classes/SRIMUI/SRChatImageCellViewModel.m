//
//  SRChatImageCellViewModel.m
//  addcnos
//
//  Created by addcnos on 2019/11/11.
//  Copyright © 2019 addcnos All rights reserved.
//

#import "SRChatImageCellViewModel.h"

@implementation SRChatImageCellViewModel

- (instancetype)initWithChatModel:(SRChatModel *)chatModel {
    if (self = [super init]) {
        self.chatModel = chatModel;
    }
    return self;
}

- (CGFloat )cellHeight {
    return 210;
}

@end
