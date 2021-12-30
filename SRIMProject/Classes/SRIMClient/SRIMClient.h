//
//  SRIMKit.h
//  WebSocketTestForiOS
//
//  Created by addcn591 on 2019/9/20.
//  Copyright © 2019 shux. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SRIMClient;

typedef NS_ENUM(NSInteger ,SRIMClientMessageType) {
    SRIMClientMessageTypeTxt,
    SRIMClientMessageTypeImg,
    SRIMClientMessageTypeCustom,
};
@protocol SRIMClientDelegate <NSObject>
@optional
/**
 Disconnect 鏈接失敗或者接收消息失敗的回調
 @param errorCode 4006  4004 失效or过期 系统错误
 */
- (void)srIMClient:(SRIMClient *_Nullable)client didReceiveErrorCode:(NSInteger)errorCode;


/**
 Connect 鏈接成功回調
 */
- (void)srIMClientCollectSuccess:(SRIMClient *_Nullable)client messageDic:(NSDictionary *_Nullable)messageDic;

/**
 接受消息成功回調
 
 @param messageType 消息類型
 @param messageDic 文本內容字典
 */
- (void)srIMClient:(SRIMClient *_Nullable)client didReceiveMessage:(SRIMClientMessageType)messageType
        messageDic:(NSDictionary *_Nullable)messageDic;



/**
 鏈接Sockect 失敗回調
 @param error 錯誤
 */
- (void)srIMClient:(SRIMClient *_Nullable)client didFailSocketWithError:(NSError *_Nullable)error;


/**
 sockect即将发起链接
 */
- (void)srIMRegisterClient:(SRIMClient *_Nullable)client;

@end
NS_ASSUME_NONNULL_BEGIN

@interface SRIMClient : NSObject


@property (nonatomic, weak) id <SRIMClientDelegate> delegate;

/// IMClient单例
+ (instancetype)shareClient;

/// 通过服务方Token注册SRIM/
/// @param token service token
- (void)registerIMServiceWithToken:(NSString *)token;
/// 直接
//- (void)conncectWithSRToken:(NSString *)token;
/// 开启IM服务，确保调用前tokeni已存在且有效
- (void)startIMService;

/// 重新连接
- (void)reconnect;

/// 断开IM连接
- (void)disconnect;

/// 获取IM连接状态
- (NSInteger )wsConnectStatus;

/// 移除本地UserDefaults中的token
- (void)removeIMToken;

/// 获取Client服务保存的token
- (NSString *)getToken;

/// 保存token
- (void)saveToken:(NSString *)token;

/// 獲取未讀消息總數
- (void)getAllNewMessageToken:(NSString *)token block:(void(^)(NSInteger count))block;
@end

NS_ASSUME_NONNULL_END
