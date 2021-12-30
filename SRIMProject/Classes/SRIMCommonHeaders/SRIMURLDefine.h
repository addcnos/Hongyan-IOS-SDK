//
//  SRIMURLDefine.h
//  SRIM
//
//  Created by Addcnhk591 on 2019/10/24.
//  Copyright © 2019 Addcnhk591. All rights reserved.
//

#ifndef SRIMURLDefine_h
#define SRIMURLDefine_h

//#define SRIMBaseURL @"https://im.debug.591.com.hk" //@"https://im.591.com.hk"

/**
 消息设置已读
 */
#define SRIMReadTargetUserMessage [[SRIMNetworkManager getBaseAPIUrl] stringByAppendingString:@"/chat/readMsg"]

/**
 获取新消息总数
 */
#define SRIMUnReadMessageCount [[SRIMNetworkManager getBaseAPIUrl] stringByAppendingString:@"/chat/getAllNewMessage"]

/**
 获取联系人在线状态
 */
#define SRIMUserOnlineStatus [[SRIMNetworkManager getBaseAPIUrl] stringByAppendingString:@"/chat/onlineStatus"]

/**
 聊天界面联系人列表
 */
#define SRIMConversationList [[SRIMNetworkManager getBaseAPIUrl] stringByAppendingString:@"/chat/users"]

/**
 获取IM双方信息
 */
#define SRIMGetConversationInfo [[SRIMNetworkManager getBaseAPIUrl] stringByAppendingString:@"/chat/getConversationInfo"]

/**
 消息到达回调
 */
#define SRIMMessagesArrival [[SRIMNetworkManager getBaseAPIUrl] stringByAppendingString:@"/messages/messageArrival"]

/**
 发消息
 */
#define SRIMSendMsg [[SRIMNetworkManager getBaseAPIUrl] stringByAppendingString:@"/messages/send"]

/**
 获取历史消息
 */
#define SRIMHistoricalMessage [[SRIMNetworkManager getBaseAPIUrl] stringByAppendingString:@"/messages/getHistoricalMessage"]

/**
 IM上传照片
*/
#define SRIMUploadPicture [[SRIMNetworkManager getBaseAPIUrl] stringByAppendingString:@"/messages/pictureUpload"]


/**
 删除联络人
*/
#define SRIMDelLiaisonPerson [[SRIMNetworkManager getBaseAPIUrl] stringByAppendingString:@"/messages/delLiaisonPerson"]

/**
 链接im
 */
#define SRIMWebSocketURL [SRIMNetworkManager getSocketAPIUrl]

//#define SRIMWebSocketURL @"wss://im.debug.591.com.hk/wss?token=%@&EIO=4&transport=websocket" //@"wss://im.591.com.hk/wss?token=%@"

/**
 IM Service注册
 */
//#define SRIMServiceURL @"https://service.debug.591.com.hk" //@"https://service.591.com.hk"

//#define SRIMRegisterToken [SRIMServiceURL stringByAppendingString:@"/api/Im/register"]

//#define SRIMGetToken [SRIMServiceURL stringByAppendingString:@"/api/Im/getToken"]
//
//#define SRIMCleanToken [SRIMServiceURL stringByAppendingString:@"/api/Im/cleanToken"]

//#define SRIMGetConversationUserInfo [SRIMServiceURL stringByAppendingString:@"/api/Im/getConversationUserInfo"]

/**
获取时间戳
*/
#define SRIMGetTimestamp [[SRIMNetworkManager getBaseAPIUrl] stringByAppendingString:@"/common/getTimestamp"]

#endif /* SRIMURLDefine_h */
