//
//  SRConversationModel.h
//  HKHouse591
//
//  Created by addcn591 on 2019/9/20.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRConversationChatModel.h"
#import "SRConversationExtendModel.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, SRConversationType) {
    SRConversationTypePrivate = 0,  //单聊
};

@interface SRConversationModel : NSObject

@property (nonatomic, strong) SRConversationExtendModel *extendModel;

@property (nonatomic, strong) SRConversationChatModel *chatModel;

@property (nonatomic, assign) SRConversationType conversationType;

@property (nonatomic, assign) NSUInteger unreadMessageCount;

@end

NS_ASSUME_NONNULL_END
