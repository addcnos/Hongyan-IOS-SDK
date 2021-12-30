//
//  SRLocalNotificationManager.h
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/10/17.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger ,SRLocalNotificationManagerType) {
    SRLocalNotificationManagerTypeDefault,
    SRLocalNotificationManagerTypeTW591,
};
@interface SRLocalNotificationManager : NSObject

+ (instancetype)shareManager;
- (void)requestLocalNotification;
- (void)sendLocalNotificationWithUserInfo:(NSDictionary *)dic messageBody:(NSString *)messageBody;
/// target_uid 对方id  target_name 对方名称
@property (nonatomic, strong) void (^touchBlock)(NSDictionary *userInfo);
/**
 设置通知栏样式
 */
@property (nonatomic, assign) SRLocalNotificationManagerType managerType;


/**
 是否自动清空推送消息
 */
@property (nonatomic, assign) BOOL isAutoClearNotification;

/**
 本地推送title
 */
@property (nonatomic, strong) NSString *locationPushTitle;

/**
 本地推送補充字段body
 */
//@property (nonatomic, strong) NSString *locationPushBodyPre;

@property (nonatomic, strong) NSArray<NSString *> *forbidReciveClassNames;


/**
 禁止接收推送
 */
@property (nonatomic, assign) BOOL forbidReciveAction;


/**
 消息个数
 */
@property (nonatomic, assign) NSInteger applicationIconBadgeNumber;
/**
 本地推送扩展字段
 */
@property (nonatomic, strong) NSDictionary *locationPushExtDic;
/**
 是否开启本地通知栏
 */
@property (nonatomic, assign) BOOL isOpenLocationNoti;
/**
 修改自定义消息在应用内推送的内容
 */
@property (nonatomic, copy, nullable) NSString * (^customMessageModify)(NSDictionary * info);

@end

NS_ASSUME_NONNULL_END
