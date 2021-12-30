//
//  SRChatModel.m
//  HKHouse591
//
//  Created by addcn591 on 2019/9/23.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRChatModel.h"
#import "SRIMDatetimeExtension.h"
@implementation SRChatModel


- (void)setSend_time:(NSString *)send_time{
    NSTimeInterval time = [SRIMDatetimeExtension getTimeStampWithTime:send_time format:nil];
    _send_time = [SRIMDatetimeExtension getDateChatDetailTimeStamp:time];
}
@end
