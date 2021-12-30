//
//  TWSecurityHelper.h
//  TWSecurityUtil
//
//  Created by linxunfeng on 2020/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWSecurityHelper : NSObject

//获取本地时间戳 注意不能修改
+ (long long)getStartTime;

+ (NSString *)timeFrom1970time;

+ (NSString *)timeFrom1970mstime;

 //注意這裡不能編碼 注釋掉
+ (NSString *)shareUrl:(NSString *)url byStr:(NSString *)byStr;

+ (NSString *)shareUrl:(NSString *)url byStrDic:(NSDictionary *)strDic;

+ (void)log:(NSString *)logStr isDebug:(BOOL)isDebug;

@end

NS_ASSUME_NONNULL_END
