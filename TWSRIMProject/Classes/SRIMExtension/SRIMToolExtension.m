//
//  SRIMToolExtension.m
//  AFNetworking
//
//  Created by 郑泽钦 on 2020/2/28.
//

#import "SRIMToolExtension.h"

@implementation SRIMToolExtension

//在viewWillDisappear 中 判断
+ (BOOL)isPushVC:(UIViewController *)vc{
    NSArray *viewControllers = vc.navigationController.viewControllers;//获取当前的视图控制其
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == vc) {
        //当前视图控制器在栈中，故为push操作
        return YES;
    }
    return NO;
}

+ (BOOL)isPodVC:(UIViewController *)vc{
    NSArray *viewControllers = vc.navigationController.viewControllers;//获取当前的视图控制其
    if ([viewControllers indexOfObject:vc] == NSNotFound) {
        //当前视图控制器不在栈中，故为pop操作
        return YES;
    }
    return NO;
}

@end
