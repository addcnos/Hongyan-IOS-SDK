//
//  SRHouseContentCellViewModel.m
//  HKHouse591
//
//  Created by addcn591 on 2019/9/23.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
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
