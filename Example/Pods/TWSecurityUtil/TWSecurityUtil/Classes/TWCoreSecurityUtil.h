//
//  TWCoreSecurityUtil.h
//  TWCommonTargetFrameWork
//
//  Created by addcnos on 2017/11/14.
//

#import <Foundation/Foundation.h>
#import "TWSecurityConfig.h"

typedef NS_ENUM(NSInteger,TWSRequestType) {
    TWSRequestGet,
    TWSRequestPost,
};

@interface TWCoreSecurityUtil : NSObject

// 获取加密后返回的参数
+ (NSDictionary *)getSignatureParameters:(NSDictionary *)parameters
                                     url:(NSString *)url
                                  method:(TWSRequestType)type
                                  config:(TWSecurityConfig *)config
                    signatureParamsBlock:(void(^)(NSDictionary *))signatureParmasBlock;

// 缓存服务时间(请根据自己业务需要，自行定时调用该方法更新时间戳)
+ (void)cacheSingntureServiceTime:(NSNumber *)timestamp
                           config:(TWSecurityConfig *)config;

/// 开启刷新时间戳的定时器（开启时会立马刷新一次时间戳）
/// @param config 配置对象
/// @param refreshHandler 刷新时间的操作(由外部决定怎么获取到时间戳，再调用 cacheSingntureServiceTime 更新)
+ (void)startRefreshTimeTimerWithConfig:(TWSecurityConfig *)config
                         refreshHandler:(void(^)(void))refreshHandler;

@end
