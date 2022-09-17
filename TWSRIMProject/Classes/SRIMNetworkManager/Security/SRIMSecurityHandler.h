//
//  SRIMSecurityHandler.h
//  TWSecurityUtil
//
//  Created by addcnos on 2020/7/22.
//


#import <TWSRIMProject/TWSecurityUtil.h>
/**
 IM的签名处理工具，跟业务有关！！！
 - 如果使用者也是一样的处理逻辑，则可以直接拿去使用
 - 如果不同，则自定义Handler
 */

NS_ASSUME_NONNULL_BEGIN

@interface SRIMSecurityHandler : NSObject

+ (NSDictionary *)getSignatureParameters:(NSDictionary *)parameters
                                     url:(NSString *)url
                             isSignature:(BOOL)isSignature
                                  method:(TWSRequestType)type
                                 flagDic:(NSMutableDictionary *)flagDic
                                 config:(TWSecurityConfig *)config;

//错误的时间处,并且重新发起数据请求，限制3次 isFail = YES 需要重新请求
+ (void)checkSignatureErrorResponse:(id)json
                            flagDic:(NSMutableDictionary *)flagDic
                            config:(TWSecurityConfig *)config
                     signatureBlock:(void(^)(BOOL isFail))signatureBlock;

//跟新时间
+ (void)refreshSignatureServiceTime:(NSString *)fetchServiceTimeUrl
                             config:(TWSecurityConfig *)config;

@end

NS_ASSUME_NONNULL_END
