//
//  UIViewController+HHTransition.m
//  https://github.com/yuwind/HHTransition
//
//  Created by 豫风 on 2017/2/19.
//  Copyright © 2017年 豫风. All rights reserved.
//

#import "UIViewController+HHTransition.h"
#import "VCTransitionDelegate.h"
#import <objc/runtime.h>

static char * const interactionDelegateKey = "interactionDelegateKey";
static char * const transitionDelegateKey  = "transitionDelegateKey";
static char * const animationStyleKey      = "animationStyleKey";

@interface UIViewController ()

@property (nonatomic, assign) AnimationStyle animationStyle;
@property (nonatomic, strong) VCTransitionDelegate *transitionDelegate;
@property (nonatomic, strong) VCInteractionDelegate *interactionDelegate;

@end

@implementation UIViewController (HHPresent)

+ (void)load
{
    Class class = [self class];
    
    SEL originalSelector = @selector(dismissViewControllerAnimated:completion:);
    SEL swizzledSelector = @selector(hh_dismissViewControllerAnimated:completion:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)setAnimationStyle:(AnimationStyle)animationStyle
{
    objc_setAssociatedObject(self, animationStyleKey, @(animationStyle), OBJC_ASSOCIATION_ASSIGN);
}
- (AnimationStyle)animationStyle
{
    return [objc_getAssociatedObject(self, animationStyleKey) integerValue];
}

- (void)setTransitionDelegate:(VCTransitionDelegate *)transitionDelegate
{
    objc_setAssociatedObject(self, transitionDelegateKey, transitionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (VCTransitionDelegate *)transitionDelegate
{
    return objc_getAssociatedObject(self, transitionDelegateKey);
}

- (void)setInteractionDelegate:(VCInteractionDelegate *)interactionDelegate
{
    objc_setAssociatedObject(self, interactionDelegateKey, interactionDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (VCInteractionDelegate *)interactionDelegate
{
    return objc_getAssociatedObject(self, interactionDelegateKey);
}

- (void)hh_presentCircleVC:(UIViewController *)controller point:(CGPoint)point completion:(void (^)(void))completion
{
    [self hh_presentVC:controller type:AnimationStyleCircle point:point completion:completion];
}

- (void)hh_presentVC:(UIViewController *)controller type:(AnimationStyle)style completion:(void (^)(void))completion
{
    [self hh_presentVC:controller type:style point:CGPointZero completion:completion];
}
- (void)hh_presentVC:(UIViewController *)controller type:(AnimationStyle)style point:(CGPoint)point completion:(void (^)(void))completion
{
    self.transitionDelegate = [VCTransitionDelegate new];
    self.transitionDelegate.touchPoint = point;
    controller.animationStyle = style;
    controller.modalPresentationStyle = UIModalPresentationCustom;
    controller.transitioningDelegate = self.transitionDelegate;
    
    [self presentViewController:controller animated:YES completion:completion];
}
- (void)hh_dismissWithPoint:(CGPoint)point completion:(void (^)(void))completion
{
    VCTransitionDelegate *transitionDelegate = self.transitioningDelegate;
    transitionDelegate.touchPoint = point;
    
    [self dismissViewControllerAnimated:YES completion:completion];
}
- (void)hh_dismissViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    if (!animated) {
        [self.presentingViewController resetInitialInfo];
    }
    [self hh_dismissViewControllerAnimated:animated completion:completion];
}
- (void)resetInitialInfo
{
    if (CGPointEqualToPoint(self.view.layer.anchorPoint, CGPointMake(0.5, 0.5))) {
        return;
    }
    self.view.alpha = 1;
    [self.view.layer setTransform:CATransform3DIdentity];
    self.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    self.view.layer.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}

- (UIView *)hh_transitionAnimationView{
    return nil;
}

@end


@implementation UINavigationController (HHPush)

- (void)hh_pushViewController:(UIViewController *)viewController style:(AnimationStyle)style
{
    VCInteractionDelegate *interaction = [VCInteractionDelegate new];
    interaction.navigation = self;
    interaction.delegate = self.delegate;
    viewController.interactionDelegate = interaction;
    viewController.animationStyle = style;
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:interaction action:NSSelectorFromString(@"edgePanAction:")];
    edgePan.edges = UIRectEdgeLeft;
    [viewController.view addGestureRecognizer:edgePan];
    self.delegate = interaction;
    [self pushViewController:viewController animated:YES];
}

@end
