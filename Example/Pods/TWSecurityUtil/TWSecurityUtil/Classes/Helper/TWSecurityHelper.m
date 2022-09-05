//
//  TWSecurityHelper.m
//  TWSecurityUtil
//
//  Created by addcnos on 2020/7/22.
//

#import "TWSecurityHelper.h"
#import "TWSecurityHeader.h"
#import "TWSecurityConfig.h"

@implementation TWSecurityHelper


//获取本地时间戳 注意不能修改
+ (long long)getStartTime {
    return [[self timeFrom1970time] longLongValue];
}

+ (NSString *)timeFrom1970time {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

+ (NSString *)timeFrom1970mstime {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970] * 1000;
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time];
    return timeString;
}

// 注意這裡不能編碼 注釋掉
+ (NSString *)shareUrl:(NSString *)url byStr:(NSString *)byStr{
    NSString *shareUrl = @"";
    if ([url rangeOfString:@"?"].location==NSNotFound) {
        shareUrl = [NSString stringWithFormat:@"%@?%@",url,byStr];
    }else{
        shareUrl = [NSString stringWithFormat:@"%@&%@",url,byStr];
    }
    return shareUrl;
}

+ (NSString *)shareUrl:(NSString *)url byStrDic:(NSDictionary *)strDic{
    NSString *shareUrl = url;
    for (NSString *key in strDic.allKeys) {
        NSString *value = strDic[key];
        shareUrl = [self shareUrl:shareUrl byStr:[NSString stringWithFormat:@"%@=%@",key,value]];
    }
    return shareUrl;
}

+ (void)log:(NSString *)logStr isDebug:(BOOL)isDebug {
    if(isDebug) {
        NSLog(@"DEBUG -- %@", logStr);
    }
}

@end
