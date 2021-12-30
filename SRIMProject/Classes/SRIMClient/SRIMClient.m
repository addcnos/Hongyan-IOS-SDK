//
//  SRIMKit.m
//  WebSocketTestForiOS
//
//  Created by addcn591 on 2019/9/20.
//  Copyright © 2019 shux. All rights reserved.
//

#import "SRIMClient.h"
#import <SocketRocket/SocketRocket.h>
#import "SRLocalNotificationManager.h"
#import "SRIMURLDefine.h"
#import "SRIMNetworkManager.h"
#import <PINCache/PINCache.h>
#import "SRIMConsts.h"
#import "SRIMUtility.h"
@interface SRIMClient ()<SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *webSocket;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger reconnectTimes;

//@property (nonatomic, copy) NSString *idCode;

@end

@implementation SRIMClient

+ (instancetype)shareClient {
    static SRIMClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[SRIMClient alloc] init];
    });
    return client;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)registerIMServiceWithToken:(NSString *)token {
    [self saveToken:token];
    [self startIMService];
    if ([self.delegate respondsToSelector:@selector(srIMRegisterClient:)]) {
        [self.delegate srIMRegisterClient:self];
    }
}


- (void)startIMService {
    NSString *token = [self getToken];
    if (!token || [token isEqual:[NSNull null]] || token.length == 0) {
        NSAssert(token, @"token不可为空");
        return;
    }
    [self conncectWithSRToken:token];
}


- (void)reconnect {
    if (self.webSocket && self.webSocket.readyState == SR_OPEN) {
        return;
    }
    [self conncectWithSRToken:[self getToken]];
}

- (void)disconnect {
    if (self.webSocket && self.webSocket.readyState == SR_OPEN) {
        self.webSocket.delegate = nil;
        [self.webSocket close];
    }
}

- (void)conncectWithSRToken:(NSString *)token {
    self.webSocket.delegate = nil;
    [self.webSocket close];
    NSString *socketUrlString = [NSString stringWithFormat:@"%@?token=%@&EIO=4&transport=websocket",SRIMWebSocketURL,token];
    NSURL *url = [NSURL URLWithString:socketUrlString];
    if (url) {
        self.webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:socketUrlString] protocols:@[] allowsUntrustedSSLCertificates:YES];
        self.webSocket.delegate = self;
        [self.webSocket open];
    }
    else {
        [self startIMService];
    }
}

- (void)sendPing:(id)sender {
    NSData *data = [@"test_ping" dataUsingEncoding:NSUTF8StringEncoding];// test_ping
    if ([self wsConnectStatus] == 1) {
        //        [self.webSocket sendPing:data];
        [self.webSocket send:data];
    }
}

#pragma mark - Api
- (void)getAllNewMessageToken:(NSString *)token block:(void(^)(NSInteger count))block{
    SRIMWeakSelf(weakSelf);
    NSString *url = [NSString stringWithFormat:@"%@?token=%@",SRIMUnReadMessageCount, token];
    [[SRIMNetworkManager shareManager] loadDataWithUrl:url method:@"GET" parameters:nil success:^(id  _Nonnull responseObject) {
        NSInteger count = 0;
        if(SRIMIsDictionaryClass(responseObject)) {
            NSInteger code = [responseObject[@"code"] integerValue];
            if (code == 200) {
                count = [responseObject[@"data"][@"count"] integerValue];
            }
        }
        if (block) {
            block(count);
        }
    } failureBlock:^(NSError * _Nonnull error) {
        NSInteger code = error.code;
        if (code == 4006 || code == 4004) { // token失效了 临时处理，后面统一
            if ([weakSelf.delegate respondsToSelector:@selector(srIMClient:didReceiveErrorCode:)]) {
                [weakSelf.delegate srIMClient:SRIMClient.shareClient didReceiveErrorCode:code];
            }
        }
        if (block) {
            block(0);
        }
    }];
    
}

#pragma mark - SRWebSocketRocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    SRIMLog(@"Websocket Connected");
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(sendPing:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    SRIMLog(@":( Websocket Failed With Error %@", error);
    if (error.code == 504 || error.code == 57) {
        //Timeout Connecting to Server
        [self conncectWithSRToken:[self getToken]];
    }
    else {
        self.webSocket.delegate = nil;
        self.webSocket = nil;
    }
    if ([self.delegate respondsToSelector:@selector(srIMClient:didFailSocketWithError:)]) {
        [self.delegate srIMClient:self didFailSocketWithError:error];
    }
    
    //    [self reconnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    SRIMLog(@"receiveMessage:->>>>%@", message);
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *messageDic = @{};
    if ([json isKindOfClass:[NSArray class]]) {
        NSArray *messageArr = (NSArray *)json;
        messageDic = messageArr.firstObject;
    }
    else if ([json isKindOfClass:[NSDictionary class]]) {
        messageDic = (NSDictionary *)json;
    }
    
    if ([messageDic objectForKey:@"mode"]) {
        NSString *mode = [messageDic objectForKey:@"mode"];
        SRIMLog(@"mode:%@", mode);
    }
    else {
        NSString *type = messageDic[@"type"];
        if ([type isEqualToString:@"Sys:Disconnect"]) {
            NSDictionary *content = messageDic[@"content"];
            NSInteger code = [content[@"code"] integerValue];
            if (code == 4006 || code == 4004) {
                //Token失效or过期 系统错误
                [self removeIMToken];
                //                [self cleanIMToken];
            }
            if ([self.delegate respondsToSelector:@selector(srIMClient:didReceiveErrorCode:)]) {
                [self.delegate srIMClient:self didReceiveErrorCode:code];
            }
        }
        else if ([type isEqualToString:@"Sys:Connect"]) { //鏈接成功
            if ([self.delegate respondsToSelector:@selector(srIMClientCollectSuccess:messageDic:)]) {
                [self.delegate srIMClientCollectSuccess:self messageDic:messageDic];
            }
        }else if ([type isEqualToString:SRIMMessageTypeTxt] || [type isEqualToString:SRIMMessageTypeCustom] || [type isEqualToString:SRIMMessageTypeImg]){
            SRIMLog(@"=====>>>>>>>>>>>>>>>>>ReceiveMessage: \"%@\"", json);
            [[NSNotificationCenter defaultCenter] postNotificationName:SRIMDidReceiveChatMessageNotification object:nil userInfo:messageDic];
            
            
            NSString *shareContent = nil;
            SRIMClientMessageType messageType = SRIMClientMessageTypeTxt;
            NSDictionary *contentDic = messageDic[@"content"];
            if (SRIMIsDictionaryClass(contentDic)) {
                if ([type isEqualToString:SRIMMessageTypeTxt]) {
                    shareContent = SRIMNullClass(contentDic[@"content"]);
                }else if ([type isEqualToString:SRIMMessageTypeCustom]) {
                    shareContent = SRIMNullClass(contentDic[@"shareContent"]);
                    messageType = SRIMClientMessageTypeCustom;
                }else if ([type isEqualToString:SRIMMessageTypeImg]) {
                    shareContent = @"[圖片]";
                    messageType = SRIMClientMessageTypeImg;
                }
            }
            
            if ([self.delegate respondsToSelector:@selector(srIMClient:didReceiveMessage:messageDic:)]) {
                [self.delegate srIMClient:self didReceiveMessage:messageType messageDic:messageDic];
            }
            
            NSString *fromUser = messageDic[@"from_uid"];
            /// 独立实现 回调如下
            if (shareContent && fromUser) {
                SRLocalNotificationManager *notiManager = [SRLocalNotificationManager shareManager];
                if (notiManager.isOpenLocationNoti) {
                    [[SRLocalNotificationManager shareManager] sendLocalNotificationWithUserInfo:messageDic messageBody:shareContent];
                }
            }
        }
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(nonnull NSString *)string
{
    SRIMLog(@"didReceiveMessageWithString \"%@\"", string);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    SRIMLog(@"WebSocket closed code:%zi - reason:%@", code,reason);
    [self.timer invalidate];
    self.timer = nil;
    if (code == SRStatusCodeGoingAway) {
        if ([self getToken] && ![[self getToken] isEqual:[NSNull null]]) {
            [self conncectWithSRToken:[self getToken]];
        }
        else {
            self.webSocket.delegate = nil;
            self.webSocket = nil;
        }
    }
    else {
        self.webSocket = nil;
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload;
{
    NSString *pongString = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    SRIMLog(@"WebSocket received pong %@", pongString);
}

- (NSInteger )wsConnectStatus {
    return self.webSocket.readyState;
}

- (void)saveToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"SRIMConnectTokenKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeIMToken {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SRIMConnectTokenKey"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"SRIMConnectTokenKey"] isEqual:[NSNull null]]) {
        NSString *key = [SRIMConversationList stringByAppendingFormat:@"&token=%@", [self getToken]];
        [[PINCache sharedCache] removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SRIMConnectTokenKey"];
    }
}

- (NSString *)getToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"SRIMConnectTokenKey"] ? : [NSNull null];
}

@end
