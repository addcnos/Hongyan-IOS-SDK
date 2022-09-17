//
//  SRConversationModel.h
//  addcnos
//
//  Created by addcnos on 2019/9/20.
//  Copyright © 2019 addcnos All rights reserved.
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
