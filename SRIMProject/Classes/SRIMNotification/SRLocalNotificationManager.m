//
//  SRLocalNotificationManager.m
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/10/17.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRLocalNotificationManager.h"
#import <UserNotifications/UserNotifications.h>
#import "SRNotificationMessageView.h"
#import <UIKit/UIKit.h>
#import "SRIMUtility.h"
#import "SRIMConsts.h"
@interface SRLocalNotificationManager()
@property (nonatomic, strong) NSMutableArray<SRNotificationMessageView *> *messageViewArr;
@end
@implementation SRLocalNotificationManager

+ (instancetype)shareManager {
    static SRLocalNotificationManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SRLocalNotificationManager alloc] init];
    });
    return manager;
}

- (NSMutableArray *)messageViewArr{
    if (!_messageViewArr) {
        _messageViewArr = [NSMutableArray array];
    }
    return _messageViewArr;
}

- (void)requestLocalNotification {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                
            }
            else {
                
            }
        }];
    } else {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

- (void)sendLocalNotificationWithUserInfo:(NSDictionary *)dic messageBody:(NSString *)messageBody {
    NSString *target_uid = dic[@"from_uid"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:SRIMPushNotificationAuthority]) {
        BOOL status = [[NSUserDefaults standardUserDefaults] boolForKey:SRIMPushNotificationAuthority];
        if (!status) {
            return;
        }
    }
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        UIViewController *currentVC = [self getCurrentVC];
        if ([currentVC isKindOfClass:NSClassFromString(@"SRChatController")]) {
            SRIMLog(@"当前聊天页面....");
            return;
        }
        
        if (self.forbidReciveAction) {
            return;
        }
        
        for (NSString *className in self.forbidReciveClassNames) {
            if ([currentVC isKindOfClass:NSClassFromString(className)]) {
                SRIMLog(@"当前聊天页面....");
                return;
            }
        }
        
        NSString *targetNickname = dic[@"nickname"];
        NSString *targetMessage = dic[@"content"][@"content"];
        NSString *type = dic[@"type"];
        if ([type isEqualToString:SRIMMessageTypeImg]) {
            targetMessage = @"[圖片]";
        }else if([type isEqualToString:SRIMMessageTypeCustom]) {
            targetMessage = @"新消息";
            
            if(self.customMessageModify){
                targetMessage = self.customMessageModify(dic);
            }
            
        }
        __weak typeof(self) weakSelf = self;
        SRNotificationMessageView *messageView = [[SRNotificationMessageView alloc] initWithNickname:targetNickname message:targetMessage];
        if (self.managerType == SRLocalNotificationManagerTypeTW591) {
            messageView.timeLabel.hidden = YES;
            [messageView reloadMessage:[NSString stringWithFormat:@"%@:%@",targetNickname,targetMessage] name:@"即時問答"];
        }
        
        messageView.block = ^(SRNotificationMessageView * _Nonnull view) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.messageViewArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [strongSelf.messageViewArr removeAllObjects];
            [strongSelf jumpToChatControllerByTargetUid:target_uid target_name:targetNickname];
        };
        
        messageView.dissmissBlock = ^(SRNotificationMessageView * _Nonnull view) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.messageViewArr removeObject:view];
        };
        
        [messageView show];
        [self.messageViewArr addObject:messageView];
    }
    else {
        NSString *nickname = SRIMNullClass(dic[@"nickname"]);
        NSString *bodyStr = self.locationPushTitle ? [NSString stringWithFormat:@"%@:%@",nickname,messageBody] : messageBody;
        NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
        [mutableDic addEntriesFromDictionary:self.locationPushExtDic];
        [mutableDic setObject:SRIMNullClass(dic[@"from_uid"]) forKey:@"from_uid"];
        [mutableDic setObject:nickname forKey:@"nickname"];
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            UNMutableNotificationContent *notificationContent = [[UNMutableNotificationContent alloc] init];
            [mutableDic addEntriesFromDictionary:dic];
            notificationContent.title = self.locationPushTitle ? self.locationPushTitle : nickname;
            notificationContent.body =  bodyStr;
            notificationContent.sound = [UNNotificationSound defaultSound];
            notificationContent.badge = @(self.applicationIconBadgeNumber);
            notificationContent.userInfo = mutableDic;
            NSString *identifier = mutableDic[@"msg_id"];
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1.f repeats:NO];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:notificationContent trigger:trigger];
            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                
            }];
            if (self.isAutoClearNotification) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [center removeDeliveredNotificationsWithIdentifiers:@[identifier]];
                });
            }
        } else {
            UILocalNotification *notify = [[UILocalNotification alloc] init];
            notify.fireDate = [NSDate dateWithTimeIntervalSinceNow:0.5f];
            notify.alertTitle = self.locationPushTitle ? self.locationPushTitle : nickname;
            notify.alertBody = bodyStr;
            notify.userInfo = mutableDic;
            notify.applicationIconBadgeNumber = self.applicationIconBadgeNumber;
            notify.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:notify];
            if (self.isAutoClearNotification) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] cancelLocalNotification:notify];
                });
            }
        }
    }
}

- (void)jumpToChatControllerByTargetUid:(NSString *)target_uid target_name:(NSString *)target_name {
    NSDictionary *userInfoDic = @{@"target_uid":SRIMNullClass(target_uid),@"target_name":SRIMNullClass(target_name)};
    if (self.touchBlock) {
        self.touchBlock(userInfoDic);
    }
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

@end
