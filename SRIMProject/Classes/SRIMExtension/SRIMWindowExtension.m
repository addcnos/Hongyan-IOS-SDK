//
//  SRIMWindowExtension.m
//  SRIMProject
//
//  Created by linxunfeng on 2020/8/5.
//

#import "SRIMWindowExtension.h"

@implementation UIWindow (Hierarchy)
- (UIViewController*) topMostController
{
    UIViewController *topController = [self rootViewController];
    
    while ([topController presentedViewController]) topController = [topController presentedViewController];
    
    return topController;
}

- (UIViewController*)currentViewController;
{
    UIViewController *currentViewController = [self topMostController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}
@end

@implementation SRIMWindowExtension

+ (UIViewController*)currentViewController {
    return [[UIApplication sharedApplication].keyWindow currentViewController];
}

@end


