//
//  SRConversationChatModel.h
//  HKHouse591
//
//  Created by addcn591 on 2019/9/20.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRBaseContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRConversationChatModel : NSObject

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, assign) NSInteger is_online;

@property (nonatomic, copy) NSString *last_time;

@property (nonatomic, assign) NSInteger new_msg_count;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, strong) SRBaseContentModel *content;

@end

NS_ASSUME_NONNULL_END
