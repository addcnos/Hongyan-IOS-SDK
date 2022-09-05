//
//  SRIMToolExtension.h
//  AFNetworking
//
//  Created by 郑泽钦 on 2020/2/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRIMToolExtension : NSObject

//是否podVC
+ (BOOL)isPodVC:(UIViewController *)vc;
//是否是pushVC
+ (BOOL)isPushVC:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
