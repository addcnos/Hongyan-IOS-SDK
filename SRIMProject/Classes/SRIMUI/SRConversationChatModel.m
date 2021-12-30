//
//  SRConversationChatModel.m
//  HKHouse591
//
//  Created by addcn591 on 2019/9/20.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRConversationChatModel.h"
#import "SRIMDatetimeExtension.h"
@implementation SRConversationChatModel

- (void)setLast_time:(NSString *)last_time{
    NSTimeInterval time = [SRIMDatetimeExtension getTimeStampWithTime:last_time format:nil];
    _last_time = [SRIMDatetimeExtension getDateChatListTimeStamp:time];
}

@end
