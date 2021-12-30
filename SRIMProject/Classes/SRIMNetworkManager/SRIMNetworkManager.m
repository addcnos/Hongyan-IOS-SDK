//
//  SRIMNetworkManager.m
//  SRIM
//
//  Created by Addcnhk591 on 2019/12/3.
//  Copyright © 2019 Addcnhk591. All rights reserved.
//

#import "SRIMNetworkManager.h"
#import "SRIMURLDefine.h"
#import <AFNetworking/AFNetworking.h>
#import "SRIMSecurityHandler.h"
#import "SRIMAlertExtension.h"

static NSString *const SRIMRequestMethodGet = @"GET";
static NSString *const SRIMRequestMethodPOST = @"POST";
// static NSInteger SRIMRequestSuccessCode = 200;
static NSInteger SRIMServiceRequestSuccessCode = 1;

@interface SRIMNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

/** 配置对象，建议使用单例引用起来 */
@property (nonatomic, strong) TWSecurityConfig *securityConfig;
/** 签名方式 */
@property (nonatomic, assign) SRIMSignatureParamsType signParamsType;
/** 集成项目的版本号 */
@property (nonatomic, strong) NSDictionary *extParam;

@end

@implementation SRIMNetworkManager
#define SRIMBaseDebugURL @"https://im.debug.591.com.hk"
#define SRIMBaseOnlineURL @"https://im.591.com.hk"

#define SRIMSocketDebugURL @"wss://im.debug.591.com.hk/wss"
#define SRIMSocketOnlineURL @"wss://im.591.com.hk/wss"


+ (instancetype)shareManager {
    static SRIMNetworkManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (NSString *)getBaseAPIUrl{
    SRIMNetworkManager *manager = [SRIMNetworkManager shareManager];
    if (manager.baseAPIUrl) {
        return manager.baseAPIUrl;
    }
    if (manager.isOnline) {
        return SRIMBaseOnlineURL;
    }
    return SRIMBaseDebugURL;
}

+ (NSString *)getSocketAPIUrl{
    SRIMNetworkManager *manager = [SRIMNetworkManager shareManager];
    if (manager.socketAPIUrl) {
        return manager.socketAPIUrl;
    }
    if (manager.isOnline) {
        return SRIMSocketOnlineURL;
    }
    return SRIMSocketDebugURL;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Network
- (void)uploadImageWithUrl:(NSString * _Nullable )url
                      data:(NSData *_Nullable )data
                     token:(NSString *_Nullable )token
                  filaName:(NSString *_Nullable )fileName
                   success:(SRIMSuccessBlock)successBlock
                   failure:(SRIMFailureBlock )errorBlock {
    if (!data) {
        return;
    }
    if (!token || [token isEqual:[NSNull null]] || token.length == 0) {
        return;
    }
    //重点注意：para中的data的key值要和下面文件流的name一致，不然服务器会收到字符串而不是文件。
    NSDictionary *param = @{@"picture":data,@"token":token};
    [self.manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:data name:@"picture" fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        successBlock(responseDic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"上传失败%@",error.description);
        errorBlock(error);
    }];
    
}

- (void)loadDataWithUrl:(NSString *_Nullable)urlStr
                 method:(NSString *_Nullable)method
             parameters:(NSDictionary *_Nullable)parameters
                success:(SRIMSuccessBlock )successBlock
           failureBlock:(SRIMFailureBlock )failureBlock {
    [self loadDataWithUrl:urlStr
                   method:method
               parameters:parameters
           flagDictionary:nil
                  success:successBlock
             failureBlock:failureBlock];
}

- (void)loadDataWithUrl:(NSString *_Nullable)urlStr
                 method:(NSString *_Nullable)method
             parameters:(NSDictionary *_Nullable)parameters
         flagDictionary:(NSMutableDictionary *)flagDictionary
                success:(SRIMSuccessBlock )successBlock
           failureBlock:(SRIMFailureBlock )failureBlock {
    __weak typeof(self)weakSelf = self;
    __block NSMutableDictionary *flagDic;
    if (flagDictionary) {
        flagDic = [NSMutableDictionary dictionaryWithDictionary:flagDictionary];
    }else{
        flagDic = [NSMutableDictionary dictionary];
    }
    
    TWSRequestType requestType = [method isEqualToString:SRIMRequestMethodGet] ? TWSRequestGet : TWSRequestPost;
    parameters = [self getSignatureParameters:parameters
                                          url:urlStr
                                       method:requestType
                                      flagDic:flagDic];
    
    if ([method isEqualToString:SRIMRequestMethodGet]) {
        [self.manager GET:urlStr parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf handleSuccess:responseObject url:urlStr method:method parameters:parameters flagDictionary:flagDic successBlock:successBlock failureBlock:failureBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf handleFailure:error failureBlock:failureBlock];
        }];
    }
    else if ([method isEqualToString:SRIMRequestMethodPOST]) {
        [self.manager POST:urlStr parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            //
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakSelf handleSuccess:responseObject url:urlStr method:method parameters:parameters flagDictionary:flagDic successBlock:successBlock failureBlock:failureBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakSelf handleFailure:error failureBlock:failureBlock];
        }];
    }
}

// 处理请求成功
- (void)handleSuccess:(id  _Nullable)responseObject
                  url:(NSString *_Nullable)urlStr
               method:(NSString *_Nullable)method
           parameters:(NSDictionary *_Nullable)parameters
       flagDictionary:(NSMutableDictionary *)flagDictionary
         successBlock:(SRIMSuccessBlock )successBlock
         failureBlock:(SRIMFailureBlock )failureBlock {
    // NSLog(@"url-%@ response-%@", urlStr, responseObject);
    
    __weak typeof(self)weakSelf = self;
    [self checkSignatureErrorResponse:responseObject flagDic:flagDictionary signatureBlock:^(BOOL isFail) {
        if (isFail) { // 执行循环请求 次数3次以内
            [weakSelf loadDataWithUrl:urlStr method:method parameters:parameters flagDictionary:flagDictionary success:successBlock failureBlock:failureBlock];
        } else {
            NSDictionary *dic = (NSDictionary *)responseObject;
            NSInteger status = 0;
            BOOL success = NO;
            if ([urlStr containsString:@"im"]) {
                status = [[dic objectForKey:@"code"] integerValue];
                SRIMNetworkIMCodeType codeType = (SRIMNetworkIMCodeType)status;
                switch (codeType) {
                    case SRIMNetworkIMCodeTypeSuccess:
                        success = YES;
                        break;
                    case SRIMNetworkIMCodeTypeBlacklistNoSendMsg:
                        [[SRIMAlertExtension shareManager] alert:SRIMAlertTypeBlacklistNoSendMsg message:[dic objectForKey:@"message"]];
                        break;
                    default: break;
                }
            }
            if ([urlStr containsString:@"service"]) {
                status = [[dic objectForKey:@"status"] integerValue];
                if (status == SRIMServiceRequestSuccessCode) {
                    success = YES;
                }
            }
            if (success) {
                if (successBlock) {
                    successBlock(dic);
                }
            }
            else {
                NSString *errorDomain = [dic objectForKey:@"message"];
                NSError *error = [NSError errorWithDomain:TWSNullClass(errorDomain) code:status userInfo:nil];
                if (failureBlock) {
                    failureBlock(error);
                }
            }
        }
    }];
}

// 处理请求失败
- (void)handleFailure:(NSError * _Nonnull)error failureBlock:(SRIMFailureBlock )failureBlock {
    if (failureBlock) {
        failureBlock(error);
    }
}

#pragma mark - Signature
- (void)setupSignaturePropertiesWithType:(SRIMSignatureParamsType)type
                          securityConfig:(TWSecurityConfig *)securityConfig
                                extParam:(NSDictionary *)extParam
              needRefreshTimestampTimely:(BOOL)needRefreshTimestampTimely {
    self.signParamsType = type;
    self.extParam = extParam;
    self.securityConfig = securityConfig;
    
    switch (type) {
        case SRIMSignatureParamsTypeNone: return; // 不签名
        default: break;
    }
    
    if (needRefreshTimestampTimely) { // 需要定时刷新
        [TWCoreSecurityUtil startRefreshTimeTimerWithConfig:securityConfig refreshHandler:^{
            [SRIMSecurityHandler refreshSignatureServiceTime:SRIMGetTimestamp config:securityConfig];
        }];
    } else { // 先刷新一次
        [SRIMSecurityHandler refreshSignatureServiceTime:SRIMGetTimestamp config:securityConfig];
    }
}

// 获取签名后的参数字典
- (NSDictionary *)getSignatureParameters:(NSDictionary *)parameters
                                     url:(NSString *)url
                                  method:(TWSRequestType)type
                                 flagDic:(NSMutableDictionary *)flagDic{
    // 是否需要签名
    BOOL isSignature = self.signParamsType != SRIMSignatureParamsTypeNone;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if(self.extParam.count) [dict addEntriesFromDictionary:self.extParam];
//    dict[@"version"] = TWSNullClass(self.version);
//    dict[@"device"] = @"ios";
    return [SRIMSecurityHandler getSignatureParameters:[NSDictionary dictionaryWithDictionary:dict]
                                                   url:url
                                           isSignature:isSignature
                                                method:type
                                               flagDic:flagDic
                                                config:self.securityConfig];
}

// 校验签名后的请求结果
- (void)checkSignatureErrorResponse:(id)json
                            flagDic:(NSMutableDictionary *)flagDic
                     signatureBlock:(void(^)(BOOL isFail))signatureBlock {
    [SRIMSecurityHandler checkSignatureErrorResponse:json
                                              flagDic:flagDic
                                              config:self.securityConfig
                                       signatureBlock:signatureBlock];
}


#pragma mark - Getter

- (AFHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer.timeoutInterval = 20.f;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"image/jpeg",@"image/png",@"application/octet-stream",@"text/json",nil];
    }
    return _manager;
}

@end
