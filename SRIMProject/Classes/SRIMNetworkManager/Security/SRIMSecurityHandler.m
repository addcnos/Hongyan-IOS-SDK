//
//  SRIMSecurityHandler.m
//  TWSecurityUtil
//
//  Created by addcnos on 2020/7/22.
//

#import "SRIMSecurityHandler.h"
#import "SRIMNetworkManager.h"
#import "TWSecurityHelper.h"
#import "TWCoreSecurityUtil.h"
#import <TWSecurityUtil/TWSecurityHelper.h>

static NSString *SignatureStatusKey = @"SignatureStatusKey";
static NSString *SignatureCountKey = @"SignatureCountKey";

static NSString *GetServiceTimeCountKey = @"GetServiceTimeCountKey";

@implementation SRIMSecurityHandler

+ (NSDictionary *)getSignatureParameters:(NSDictionary *)parameters
                                     url:(NSString *)url
                             isSignature:(BOOL)isSignature
                                  method:(TWSRequestType)type
                                 flagDic:(NSMutableDictionary *)flagDic
                                 config:(TWSecurityConfig *)config {
    if (isSignature) {
        if(flagDic) [flagDic setObject:@(YES) forKey:SignatureStatusKey];
        return  [TWCoreSecurityUtil getSignatureParameters:parameters url:url method:type config:config signatureParamsBlock:^(NSDictionary *params) {
            for (NSString *key in params.allKeys) {
                [flagDic setValue:params[key] forKey:key];
            }
        }];
    }
    return parameters;
}


//更新时间差
+ (void)refreshSignatureServiceTime:(NSString *)fetchServiceTimeUrl
                             config:(TWSecurityConfig *)config {
    [self requestServerTime:fetchServiceTimeUrl params:nil block:^(NSNumber *timestamp) {
        // 刷新时间戳
        [TWCoreSecurityUtil cacheSingntureServiceTime:timestamp config:config];
        // 打印
        NSString *logStr = [NSString stringWithFormat:@"timestamp - %@", [[NSUserDefaults standardUserDefaults] valueForKey:config.saveServiceTimeKey]];
        [TWSecurityHelper log:logStr isDebug:config.isDebug];
    }];
}

//时间请求
+ (void)requestServerTime:(NSString *)fetchServiceTimeUrl
                   params:(NSMutableDictionary *)paramDic
                    block:(void(^)(NSNumber * timestamp))serverTimestampBlock{
    __block NSMutableDictionary *param = [self requestServerCommonCycle:fetchServiceTimeUrl params:paramDic isNeedAdd:NO block:nil];
    NSNumber *timeNumber = [param objectForKey:GetServiceTimeCountKey];
    if (timeNumber.integerValue<2) {// 限制2次请求服务时间戳
        __weak typeof(self) weakSelf = self;
        [[SRIMNetworkManager shareManager] loadDataWithUrl:fetchServiceTimeUrl method:@"GET" parameters:@{@"rand":[TWSecurityHelper timeFrom1970mstime]} success:^(id  _Nonnull json) {
            BOOL isSuccess = NO;
            if (json&&TWSIsDictionaryClass(json)) {
                NSString *code = json[@"code"];
                if (code && [code integerValue] == 200 && json[@"data"] && TWSIsDictionaryClass(json[@"data"])) {
                    NSDictionary *data = json[@"data"];
                    if (data[@"_timestamp"]) {
                        isSuccess = YES;
                        if (serverTimestampBlock) {
                            serverTimestampBlock([NSNumber numberWithLongLong:[data[@"_timestamp"] longLongValue]]);
                        }
                    }
                }
            }
            if (!isSuccess) {
                [weakSelf requestServerCommonCycle:fetchServiceTimeUrl params:param isNeedAdd:YES block:serverTimestampBlock];
            }
        } failureBlock:^(NSError * _Nonnull error) {
            [weakSelf requestServerCommonCycle:fetchServiceTimeUrl params:param isNeedAdd:YES block:serverTimestampBlock];
        }];
    }else{
        if (serverTimestampBlock) {
            serverTimestampBlock([NSNumber numberWithLongLong:[TWSecurityHelper getStartTime]]);
        }
    }
}

//错误的时间处理 signatureBlock 必须执行返回
+ (void)checkSignatureErrorResponse:(id)json
                            flagDic:(NSMutableDictionary *)flagDic
                            config:(TWSecurityConfig *)config
                     signatureBlock:(void(^)(BOOL isFail))signatureBlock{
    if (flagDic[SignatureStatusKey] && TWSIsDictionaryClass(json)) {
        NSString *code = TWSNSNumToNSString(json[@"code"]);
        if (code && code.integerValue == 4005) { // 签验失败
            NSInteger count = [flagDic[SignatureCountKey] integerValue];
            if (count < 3) {
                [TWSecurityHelper log:[NSString stringWithFormat:@"错误的签名请求次数 flagDic = %@",flagDic] isDebug:config.isDebug];
                [flagDic setObject:@(count+1) forKey:SignatureCountKey];
                if (signatureBlock) signatureBlock(YES);
            }else{
                if (signatureBlock) signatureBlock(NO);
            }
        }else{
            if (signatureBlock) signatureBlock(NO);
        }
    }else{
        if (signatureBlock) signatureBlock(NO);
    }
}

//重复请求时间
+ (NSMutableDictionary *)requestServerCommonCycle:(NSString *)fetchServiceTimeUrl
                                           params:(NSMutableDictionary *)paramDic
                                        isNeedAdd:(BOOL)isNeedAdd
                                            block:(void(^)(NSNumber *timestamp))serverTimestampBlock{
    if (!paramDic) {
        paramDic = [NSMutableDictionary dictionary];
    }
    if (![paramDic allKeys].count || ![paramDic objectForKey:GetServiceTimeCountKey]) {
        [paramDic setObject:@(0) forKey:GetServiceTimeCountKey];
    }
    NSNumber *timeNumber = [paramDic objectForKey:GetServiceTimeCountKey];
    if (isNeedAdd) {
        [paramDic setObject:[NSNumber numberWithInteger:(timeNumber.integerValue+1)] forKey:GetServiceTimeCountKey];
        [self requestServerTime:fetchServiceTimeUrl params:paramDic block:serverTimestampBlock];
    }
    return paramDic;
}

@end
