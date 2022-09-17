//
//  SRChatModel.h
//  addcnos
//
//  Created by addcnos on 2019/9/23.
//  Copyright © 2019 addcnos All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRBaseContentModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SRIMMessageSendStatus) {
    SRIMMessageSendStatusArrival = 0, //默认为已到达
    SRIMMessageSendStatusSending,     //发送中
    SRIMMessageSendStatusFailure,      //发送失败
    SRIMMessageSendStatusPrepare     //即将发送
};

@interface SRChatModel : NSObject

@property (nonatomic, assign) NSInteger arrivals_callback;

@property (nonatomic, strong) SRBaseContentModel *content;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSString *from_uid;

@property (nonatomic, assign) NSInteger chat_id;

@property (nonatomic, assign) NSInteger message_direction;

@property (nonatomic, copy) NSString *msg_id;

@property (nonatomic, copy) NSString *send_time;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *target_uid;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) SRIMMessageSendStatus sendStatus;

@end

NS_ASSUME_NONNULL_END
