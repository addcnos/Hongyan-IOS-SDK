//
//  TWCoreSecurityUtil.m
//  TWCommonTargetFrameWork
//
//  Created by addcnos on 2017/11/14.
//

#import "TWCoreSecurityUtil.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSString+TWSUtil.h"
#import "TWSecurityHelper.h"
#import "TWSecurityHeader.h"

#define kCipherRandomArrKey ((uint8_t[]){'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9'})

@implementation TWCoreSecurityUtil

#pragma mark - Public Method

+ (void)startRefreshTimeTimerWithConfig:(TWSecurityConfig *)config
                         refreshHandler:(void(^)(void))refreshHandler {
    if (config.timer) {
        dispatch_source_cancel(config.timer);
    }
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    config.timer = timer;
    dispatch_source_set_timer(config.timer, DISPATCH_TIME_NOW, config.refreshTime * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, refreshHandler);
    // 启动定时器
    dispatch_resume(timer);
}

#pragma mark -- Api Signature
+ (NSDictionary *)getSignatureParameters:(NSDictionary *)parameters
                                     url:(NSString *)url
                                  method:(TWSRequestType)type
                                  config:(TWSecurityConfig *)config
                    signatureParamsBlock:(void(^)(NSDictionary *))signatureParmasBlock {
    NSNumber *timer = config.localCulNumberMinusServerTime;
    if (!timer) {
        NSNumber *cacheTimer = [self getCacheSingntureServiceTimeWithConfig:config];
        config.localCulNumberMinusServerTime = cacheTimer;
        timer = cacheTimer;
    }
    parameters = [TWCoreSecurityUtil getSignatureWithAlgorithmUrl:url
                                                    timestamp:[NSNumber numberWithLongLong:timer.longLongValue + [TWSecurityHelper getStartTime]]
                                                        param:parameters
                                                       method:type
                                                       config:config
                                         signatureParamsBlock:signatureParmasBlock];
    [TWSecurityHelper log:[NSString stringWithFormat:@"getSignatureUrl : %@", [TWSecurityHelper shareUrl:url byStrDic:parameters]] isDebug:config.isDebug];
    return parameters;
}

// 获取缓存的签名时间 有效期1小时
+ (NSNumber *)getCacheSingntureServiceTimeWithConfig:(TWSecurityConfig *)config {
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:config.saveServiceTimeKey];
    NSNumber *time = dic[@"time"];
    NSDate *date = dic[@"date"];
    if (time && date && TWSIsNumberClass(time) && TWSIsDateClass(date)) {
        if (fabs([date timeIntervalSinceNow]) < config.refreshTime) {
            return time;
        }else{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:config.saveServiceTimeKey];
        }
    }
    return nil;
}

//缓存服务时间
+ (void)cacheSingntureServiceTime:(NSNumber *)timestamp
                           config:(TWSecurityConfig *)config {
    if (TWSIsNumberClass(timestamp)) {
        NSNumber *time = [NSNumber numberWithLongLong:(timestamp.longLongValue-[TWSecurityHelper getStartTime])];
        config.localCulNumberMinusServerTime = time;
        [[NSUserDefaults standardUserDefaults] setObject:@{@"time":TWSNullClass(time),@"date":[NSDate date]} forKey:config.saveServiceTimeKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [TWSecurityHelper log:[NSString stringWithFormat:@"localCulNumberMinusServerTime = %lld",time.longLongValue] isDebug:config.isDebug];
    }
}

#pragma mark - Private Method
#pragma mark -- Api Signature
//8位数随机字符串生成
+ (NSString *)getRandomStr:(NSInteger)count
                    config:(TWSecurityConfig *)config {
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:kCipherRandomArrKey length:sizeof(kCipherRandomArrKey)] encoding:NSASCIIStringEncoding];
    NSMutableString *randomStr = [NSMutableString string];
    for (NSInteger index = 0; index<count; index++) {
        [randomStr appendString:[result substringWithRange:NSMakeRange((arc4random() % result.length), 1)]];
    }
//    [randomStr insertString:@"z" atIndex:0];
    [TWSecurityHelper log:[NSString stringWithFormat:@"生成的随机数:----%@",randomStr] isDebug:config.isDebug];
    return [randomStr stringByAppendingString:@""];
}

// 參數值排序算法
+ (NSString *)getSortParamStr:(NSDictionary *)param url:(NSString *)url{
    if (!param) {
        return @"";
    }
    NSArray *keys = [[param allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSLiteralSearch];
    }];
    __block NSMutableArray *sigitureArr = [NSMutableArray array];
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id value = TWSNullClass(param[obj]);
        if (!TWSIsDictionaryClass(value) && !TWSIsArrayClass(value)) {
            //注意如涉及签名 其有中文的get请求需使用 其右边方法 [HouseTool getUrl:GetSearchlistUrl param:params isSame:YES isPwd:NO]
//            if ([url containsString:@"action=businessList"] && IsStrClass(obj) && [obj isEqualToString:@"keywords"]) { //单独处理商业keywords 中文编码问题
//                value = [HouseTool urlEncode:value stringEncoding:NSUTF8StringEncoding];
//            }
            [sigitureArr addObject:[NSString stringWithFormat:@"%@=%@",obj,value]];
        }else{
//            TWSLog(@"存在异常类型 = %@",value);
        }
    }];
    NSString *sigitureStr = [sigitureArr componentsJoinedByString:@"`"];
    //    ZQLog(@"signature = %@",sigitureStr);
    return sigitureStr;
    
}

//签名算法
+ (NSMutableDictionary *)getSignatureWithAlgorithmUrl:(NSString *)url
                                            timestamp:(NSNumber *)timestamp
                                                param:(NSDictionary *)param
                                               method:(TWSRequestType)type
                                               config:(TWSecurityConfig *)config
                                 signatureParamsBlock:(void(^)(NSDictionary *))signatureParmasBlock {
    if ([self isEmpty:url]) {
        return nil;
    }
//    ZQLog(@"url:-------------%@\n",url);
    //路径
    NSDictionary *ulrParams = [self urlPropertyParamFromUrlString:url];
//    ZQLog(@"url数据:-------------%@\n",ulrParams);
    NSString *urlPath = [NSString stringWithFormat:@"%@%@",ulrParams[@"host"],TWSNullClass(ulrParams[@"path"])];
//    ZQLog(@"urlPath数据:-------------%@\n",urlPath);
    //参数字符串
//    param = [HouseTool dictionaryAbortNullToString:param];
    NSMutableDictionary *realParam = [NSMutableDictionary dictionary];
    
    if (param) {
        [realParam addEntriesFromDictionary:param];
    }
    
    //方式
    NSString *methodStr = @"POST";
    //Get 参数拼接
    NSDictionary *urlDic;
    if (type == TWSRequestGet) {
        methodStr = @"GET";
        urlDic = [self dictionaryWithUrlString:url];
        if (urlDic) {
            [realParam addEntriesFromDictionary:urlDic];
        }
    }
    
    //签名加密参数
    NSString *paramStr = [NSString stringWithFormat:@"%@%@%@",methodStr,urlPath,[self getSortParamStr:realParam url:url]];
    
    //随机数
    NSString *randomStr = [self getRandomStr:8 config:config];
    
    //时间戳
    NSString *timestampStr = [NSString stringWithFormat:@"%lld",timestamp.longLongValue];
    
    NSString *apisecret = TWSNullClass(config.secret);
    
    //生成字符串
    NSString *genStr = [NSString stringWithFormat:@"%@%@%@%@",paramStr,apisecret,timestampStr,randomStr];
    
    //    ZQLog(@"genStr = %@",genStr);
    
    //生成签名
    NSString *signature = [[self md5:[self SHA256:genStr]] base64EncodeString];
    
    signatureParmasBlock(@{@"origin_signature": TWSNullClass(genStr),
                           @"signature": TWSNullClass(signature)});
    
//    [flagDic setObject:TWSNullClass(genStr) forKey:@"origin_signature"];
//    [flagDic setObject:TWSNullClass(signature) forKey:@"signature"];
//    ZQLog(@"----------------\n genStr = %@\n",genStr);
    
    NSString *apiappId = TWSNullClass(config.appId);
    
    NSDictionary *addtionDic = @{@"_timestamp":TWSNullClass(timestampStr),@"_appid":apiappId,@"_signature":TWSNullClass(signature),@"_randomstr":randomStr};
    if (type==TWSRequestGet) {
        NSMutableDictionary *getTypeDic = [NSMutableDictionary dictionary];
        if (param) {
            [getTypeDic addEntriesFromDictionary:param];
        }
        [getTypeDic addEntriesFromDictionary:addtionDic];
//        ZQLog(@"getTypeDic = %@\n----------------",getTypeDic);
        return getTypeDic;
    }else{
        [realParam addEntriesFromDictionary:addtionDic];
//        ZQLog(@"realParam = %@\n----------------",realParam);
        return realParam;
    }
}
/// 判断输入是否为空
+ (BOOL)isEmpty:(NSString *)value
{
    if (value==nil|| [value isKindOfClass:[NSNull class]] ||([value isKindOfClass:[NSString class]]&&[[value stringTrimWhitespace] isEqualToString:@""])) {
        return YES;
    }
    return NO;
}
/// 拆解url
+ (NSDictionary *)dictionaryWithUrlString:(NSString *)urlStr{
    if (urlStr && urlStr.length && [urlStr rangeOfString:@"?"].length == 1) {
        NSArray *array = [urlStr componentsSeparatedByString:@"?"];
        if (array && array.count == 2) {
            NSString *paramsStr = array[1];
            if (paramsStr.length) {
                NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
                NSArray *paramArray = [paramsStr componentsSeparatedByString:@"&"];
                for (NSString *param in paramArray) {
                    if (param && param.length) {
                        NSArray *parArr = [param componentsSeparatedByString:@"="];
                        if (parArr.count == 2) {
                            [paramsDict setObject:parArr[1] forKey:parArr[0]];
                        }
                    }
                }
                return paramsDict;
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}
+ (NSDictionary *)urlPropertyParamFromUrlString:(NSString *)urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableDictionary *urlProParam = [NSMutableDictionary dictionary];
    [urlProParam setObject:TWSNullClass(url.scheme) forKey:@"scheme"];
    [urlProParam setObject:TWSNullClass(url.host) forKey:@"host"];
    [urlProParam setObject:TWSNullClass(url.path) forKey:@"path"];
    [urlProParam setObject:TWSNullClass(url.lastPathComponent.stringByDeletingPathExtension) forKey:@"lastPathComponentDelPathExt"];
    [urlProParam setObject:TWSNullClass(url.lastPathComponent) forKey:@"lastPathComponent"];
    [urlProParam setObject:TWSNullClass(url.pathExtension) forKey:@"pathExtension"];
    [urlProParam setObject:TWSNullClass(url.query) forKey:@"query"];
    return urlProParam;
}
#pragma mark - 加密相关方法
/// 方法功能：md5 加密
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/// 加密方式,MAC算法: HmacSHA256
+ (NSString *)SHA256:(NSString *)plaintext{
    const char *str = plaintext.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), buffer);
    return [self stringFromBytes:buffer length:CC_SHA256_DIGEST_LENGTH];
}
/// 返回二进制 Bytes 流的字符串表示形式
+ (NSString *)stringFromBytes:(uint8_t *)bytes length:(int)length{
    NSMutableString *strM = [NSMutableString string];
    for (int i = 0; i < length; i++) {
        [strM appendFormat:@"%02x", bytes[i]];
    }
    return [strM copy];
}


@end
