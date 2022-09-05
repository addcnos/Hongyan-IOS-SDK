//
//  SRIMAppDelegate.m
//  SRIMProject
//
//  Created by addcnos on 12/09/2019.
//  Copyright (c) 2019 addcnos. All rights reserved.
//

#import "SRIMAppDelegate.h"
#import <SRIMProject/SRIMProject.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
// 这里是iOS10需要用到的框架
#import <UserNotifications/UserNotifications.h>
#endif

#import <CoreLocation/CoreLocation.h>

@implementation SRIMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[SRLocalNotificationManager shareManager] requestLocalNotification];
    return YES;
}

//iOS10以下版本收到推送消息调用
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    completionHandler(UIBackgroundFetchResultNewData);
    if (application.applicationState != UIApplicationStateActive) {
        //推送通知點擊處理
//        [self remoteNotificationHandler:userInfo];
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
//  iOS>=10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
API_AVAILABLE(ios(10.0)) {
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    if (userInfo) {
        NSLog(@"app位于前台通知(willPresentNotification:):%@", userInfo);
    }
    completionHandler(UNNotificationPresentationOptionAlert);
}

//  iOS>=10: 点击通知进入App时触发（杀死/切到后台唤起）
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
API_AVAILABLE(ios(10.0)) {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    [self remoteNotificationHandler:userInfo];
    if (userInfo) {
        NSLog(@"点击通知进入App时触发(didReceiveNotificationResponse:):%@", userInfo);
    }
    completionHandler();
}
#endif

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UIApplication* app = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier __block bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];//告诉系统，任务完成了，可以挂起APP了
        bgTask = UIBackgroundTaskInvalid;
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //cfde66bf9dd31f233e2eacdab932a5e8f99f3766  舒先生
    //fb3cec6fddf2169b1ec4099127b2a9a380c1a44d  591test1小姐
    //df57cff7d456c03f411f56d4b4df735c692c1f71  beyond
//    [SRIMNetworkManager shareManager].isOnline = YES;
    [[SRIMClient shareClient] registerIMServiceWithToken:@"xxxxxx"];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
