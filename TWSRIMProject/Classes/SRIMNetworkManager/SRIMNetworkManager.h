//
//  SRIMNetworkManager.h
//  SRIM
//
//  Created by addcnos on 2019/12/3.
//  Copyright © 2019 addcnos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRIMNetworkManagerHeader.h"
#import <TWSRIMProject/TWSecurityConfig.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SRIMSuccessBlock)(id responseObject);
typedef void(^SRIMFailureBlock)(NSError *error);

static NSString *const SRIMRequestMethodGet;
static NSString *const SRIMRequestMethodPOST;

@interface SRIMNetworkManager : NSObject


/**
 是否显线上api 如果使用自定义配置域名，则由外部控制
 */
@property (nonatomic, assign) BOOL isOnline;

+ (instancetype)shareManager;

/// 默认使用HK 的如果设置以下两个域名则使用各自域名配置
// 基础api 域名baseurl
@property (nonatomic, strong) NSString *baseAPIUrl;
// websocket url
@property (nonatomic, strong) NSString *socketAPIUrl;

//获取baseurl
+ (NSString *)getBaseAPIUrl;
//获取websocket url
+ (NSString *)getSocketAPIUrl;

- (void)uploadImageWithUrl:(NSString  * _Nullable )url
                      data:(NSData * _Nullable )data
                     token:(NSString * _Nullable )token
                  filaName:(NSString * _Nullable )fileName
                   success:(SRIMSuccessBlock )successBlock
                   failure:(SRIMFailureBlock )errorBlock;

- (void)loadDataWithUrl:(NSString *_Nullable)urlStr
                 method:(NSString *_Nullable)method
             parameters:(NSDictionary *_Nullable)parameters
                success:(SRIMSuccessBlock )successBlock
           failureBlock:(SRIMFailureBlock )failureBlock;

#pragma mark - Signature
/// 初始化签名参数
/// @param type 签名方式
/// @param securityConfig 签验对象
/// @param extParam 集成项目的版本号等参数
/// @param needRefreshTimestampTimely 是否定时刷新时间戳
- (void)setupSignaturePropertiesWithType:(SRIMSignatureParamsType)type
                          securityConfig:(TWSecurityConfig *)securityConfig
                                extParam:(NSDictionary *)extParam
              needRefreshTimestampTimely:(BOOL)needRefreshTimestampTimely;

@end

NS_ASSUME_NONNULL_END
