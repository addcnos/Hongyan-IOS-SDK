#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIViewController+XPModal.h"
#import "XPModalAnimatedTransitioning.h"
#import "XPModalConfiguration.h"
#import "XPModalPercentDrivenInteractiveTransition.h"
#import "XPModalPresentationController.h"
#import "XPModalTransitioningDelegate.h"
#import "XPPresentModal.h"

FOUNDATION_EXPORT double XPPresentModalVersionNumber;
FOUNDATION_EXPORT const unsigned char XPPresentModalVersionString[];

