//
//  SRIMDatetimeExtension.m
//  AFNetworking
//
//  Created by addcnos on 2019/12/18.
//

#import "SRIMDatetimeExtension.h"

@implementation SRIMDatetimeExtension

// 获取格式化时间时间戳
+ (NSTimeInterval)getTimeStampWithTime:(NSString *)time format:(NSString * _Nullable)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format ? format : @"yyyy-MM-dd HH:mm:ss"];//@"yyyy-MM-dd HH:mm:ss"
    NSDate *date = [dateFormatter dateFromString:time];
    return [date timeIntervalSince1970];
}

//会话列表显示时间显示
+ (NSString *)getDateChatListTimeStamp:(NSTimeInterval)tempMilli{

//    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:tempMilli];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init ];
    
    //2. 指定日历对象,要去取日期对象的那些部分.
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:myDate];
    
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy/MM/dd";
    } else {
        if (nowCmps.day==myCmps.day) {
            dateFmt.dateFormat = @"a hh:mm";
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
        } else if((nowCmps.day-myCmps.day)==1) {
            dateFmt.dateFormat = @"昨天";
        } else {
            if ((nowCmps.day-myCmps.day) <=7) {
                switch (comp.weekday) {
                    case 1:
                        dateFmt.dateFormat = @"星期日";
                        break;
                    case 2:
                        dateFmt.dateFormat = @"星期一";
                        break;
                    case 3:
                        dateFmt.dateFormat = @"星期二";
                        break;
                    case 4:
                        dateFmt.dateFormat = @"星期三";
                        break;
                    case 5:
                        dateFmt.dateFormat = @"星期四";
                        break;
                    case 6:
                        dateFmt.dateFormat = @"星期五";
                        break;
                    case 7:
                        dateFmt.dateFormat = @"星期六";
                        break;
                    default:
                        break;
                }
            }else {
                dateFmt.dateFormat = @"MM-dd hh:mm";
            }
        }
    }
    return [dateFmt stringFromDate:myDate];
}

//聊天列表显示时间:
+ (NSString *)getDateChatDetailTimeStamp:(NSTimeInterval)tempMilli{
//    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:tempMilli];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc ] init ];
    
    //2. 指定日历对象,要去取日期对象的那些部分.
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:myDate];
    
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy年MM月dd日 ahh:mm"; //yyyy-MM-dd
    } else {
        if (nowCmps.day==myCmps.day) {
            dateFmt.dateFormat = @"a hh:mm";
        } else if((nowCmps.day-myCmps.day)==1) {
            dateFmt.dateFormat = @"昨天 a hh:mm";
        } else {
            if ((nowCmps.day-myCmps.day) <=7) {
                switch (comp.weekday) {
                    case 1:
                        dateFmt.dateFormat = @"星期日 a hh:mm";
                        break;
                    case 2:
                        dateFmt.dateFormat = @"星期一 a hh:mm";
                        break;
                    case 3:
                        dateFmt.dateFormat = @"星期二 a hh:mm";
                        break;
                    case 4:
                        dateFmt.dateFormat = @"星期三 a hh:mm";
                        break;
                    case 5:
                        dateFmt.dateFormat = @"星期四 a hh:mm";
                        break;
                    case 6:
                        dateFmt.dateFormat = @"星期五 a hh:mm";
                        break;
                    case 7:
                        dateFmt.dateFormat = @"星期六 a hh:mm";
                        break;
                    default:
                        break;
                }
            }else {
                dateFmt.dateFormat = @"MM-dd ahh:mm";
            }
        }
    }
    dateFmt.AMSymbol = @"上午";
    dateFmt.PMSymbol = @"下午";
    NSString *dateTime = [dateFmt stringFromDate:myDate];
    return dateTime;
}


+ (NSString *)currentTimestamp {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *currentTimeStamp = [formatter stringFromDate:date];
    return currentTimeStamp;
}
@end
