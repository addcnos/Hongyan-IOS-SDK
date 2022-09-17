//
//  SRConversationChatModel.m
//  addcnos
//
//  Created by addcnos on 2019/9/20.
//  Copyright © 2019 addcnos All rights reserved.
//

#import "SRConversationChatModel.h"
#import "SRIMDatetimeExtension.h"
@implementation SRConversationChatModel

- (void)setLast_time:(NSString *)last_time{
    NSTimeInterval time = [SRIMDatetimeExtension getTimeStampWithTime:last_time format:nil];
    _last_time = [SRIMDatetimeExtension getDateChatListTimeStamp:time];
}

@end
