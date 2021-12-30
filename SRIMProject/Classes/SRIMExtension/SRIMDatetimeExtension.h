//
//  SRIMDatetimeExtension.h
//  AFNetworking
//
//  Created by zhengzeqin on 2019/12/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRIMDatetimeExtension : NSObject

/**
 獲取時間戳

 @param time 需要格式化的日期
 @param format 格式化
 */
+ (NSTimeInterval)getTimeStampWithTime:(NSString *)time format:(NSString * _Nullable)format;

/**
 獲取聊天列表日期
SRIMDatetimeExtension
 @param tempMilli 時間戳
 */
+ (NSString *)getDateChatListTimeStamp:(NSTimeInterval)tempMilli;

/**
 獲取聊天詳情日期

 @param tempMilli 時間戳
 */
+ (NSString *)getDateChatDetailTimeStamp:(NSTimeInterval)tempMilli;


+ (NSString *)currentTimestamp;
@end

NS_ASSUME_NONNULL_END
