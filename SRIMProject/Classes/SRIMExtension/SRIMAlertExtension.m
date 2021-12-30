//
//  SRIMAlertExtension.m
//  SRIMProject
//
//  Created by linxunfeng on 2020/8/5.
//

#import "SRIMAlertExtension.h"
#import "SRIMWindowExtension.h"

@implementation SRIMAlertExtension

+ (instancetype)shareManager {
    static SRIMAlertExtension *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)alert:(SRIMAlertType)type message:(nullable NSString *)message {
    if (!self.openAlert) { // 没有开启提示功能
        return;
    }
    // 已开启提示功能
    if ([self.delegate respondsToSelector:@selector(alertExtension:alertType:message:)]) { // 有实现代理方法，即自定义提示功能
        [self.delegate alertExtension:self alertType:type message:message];
        return;
    }
    // 没有显示代理（使用系统提示框）
    [self systemAlertWithType:type message:message];
}

- (void)systemAlertWithType:(SRIMAlertType)type message:(nullable NSString *)msg {
    NSString *title = nil;
    NSString *message = msg;
    switch (type) {
        case SRIMAlertTypeBlacklistNoSendMsg:
            title = @"禁止发送消息";
            message = @"如有疑问，请联络客服";
            break;
            
        default:return;
    }
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) { }];
    [alert addAction:cancelAction];
    [UIApplication sharedApplication];
    [[SRIMWindowExtension currentViewController] presentViewController:alert animated:YES completion:nil];
}

@end
