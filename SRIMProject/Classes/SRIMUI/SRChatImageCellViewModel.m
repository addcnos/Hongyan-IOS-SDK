//
//  SRChatImageCellViewModel.m
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/11/11.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
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
