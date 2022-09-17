//
//  SRIMViewController.m
//  SRIMProject
//
//  Created by addcnos on 12/09/2019.
//  Copyright (c) 2019 addcnos. All rights reserved.
//

#import "SRIMViewController.h"
#import <TWSRIMProject/SRIMProject.h>
#import "ChatListExampleController.h"
#import "ChatExampleController.h"
#import "UIViewController+HHTransition.h"

@interface SRIMViewController ()<SRIMClientDelegate>

@end

@implementation SRIMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title = @"SRIMTestDemo";
    [SRIMClient shareClient].delegate = self;
    [SRLocalNotificationManager shareManager].isOpenLocationNoti = YES;
    [SRLocalNotificationManager shareManager].managerType = SRLocalNotificationManagerTypeTW591;
    
//    // 签验配置对象
//    TWSecurityConfig *securityConfig = [[TWSecurityConfig alloc] init];
//    securityConfig.appId = @"appId";
//    securityConfig.secret = @"secret";
//    securityConfig.refreshTime = 10; // 时间戳刷新时间(秒)
//    securityConfig.isDebug = YES; // (是否为debug模式，打印相关信息)
//    // 开启签名
//    [[SRIMNetworkManager shareManager] setupSignaturePropertiesWithType:SRIMSignatureParamsTypeSRIM
//                                                         securityConfig:securityConfig
//                                                                version:@"5.0.7"
//                                             needRefreshTimestampTimely:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action:(UIButton *)sender {
    
    //cfde66bf9dd31f233e2eacdab932a5e8f99f3766
    //fb3cec6fddf2169b1ec4099127b2a9a380c1a44d
//    [[SRIMClient shareClient] disconnect];
//    if (sender.tag == 0) {
//        [[SRIMClient shareClient] registerIMServiceWithToken:@"xxxxxx"];
//    }else if (sender.tag == 1) {
//        [[SRIMClient shareClient] registerIMServiceWithToken:@"xxxxxx"];
//    }
    
    if (sender.tag == 0) {
        ChatListExampleController *chatList = [[ChatListExampleController alloc] init];
        [self.navigationController pushViewController:chatList animated:YES];
    }else{
//        XPModalConfiguration *configuration = [XPModalConfiguration defaultConfiguration];
//        configuration.direction = XPModalDirectionBottom;
//        configuration.enableInteractiveTransitioning = NO;
//        CGFloat viewH = [UIScreen mainScreen].bounds.size.height - 100;
//        CGSize contentSize = CGSizeMake(CGFLOAT_MAX, viewH);
//        ChatExampleController *chatController = [[ChatExampleController alloc] init];
//        chatController.target_name = @"舒先生";
//        chatController.target_uid = @"124790";
//        chatController.hidesBottomBarWhenPushed = YES;
////        chatController.viewHeigthOff = 100;
//        chatController.viewHeight = viewH;
////        [self.navigationController pushViewController:chatController animated:YES];
//        chatController.showTopCloseView = YES;
//        [self presentModalWithViewController:chatController contentSize:contentSize configuration:configuration completion:nil];
        
        ChatExampleController *chatController = [[ChatExampleController alloc] init];
        chatController.target_name = @"舒先生";
        chatController.target_uid = @"124790";
        [self.navigationController pushViewController:chatController animated:YES];
//        chatController.showTopCloseView = YES;
    }
}

#pragma mark - SRIMClientDelegate
- (void)srIMClient:(SRIMClient *_Nullable)client didReceiveErrorCode:(NSInteger)errorCode{
    
}

- (void)srIMClientCollectSuccess:(SRIMClient *_Nullable)client messageDic:(NSDictionary *_Nullable)messageDic{
    
}

- (void)srIMClient:(SRIMClient *_Nullable)client didReceiveMessage:(SRIMClientMessageType)messageType
        messageDic:(NSDictionary *_Nullable)messageDic{
    
}

- (void)srIMClient:(SRIMClient *_Nullable)client didFailSocketWithError:(NSError *_Nullable)error{
    
}

@end
