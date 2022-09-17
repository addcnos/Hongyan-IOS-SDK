//
//  SRIMAlertExtension.h
//  SRIMProject
//
//  Created by addcnos on 2020/8/5.
//

#import <Foundation/Foundation.h>
@class SRIMAlertExtension;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SRIMAlertTypeBlacklistNoSendMsg = 4011, // 被拉黑名单，不能发消息
} SRIMAlertType;

@protocol SRIMAlertExtensionDelegate <NSObject>

@optional
- (void)alertExtension:(SRIMAlertExtension *)alertManger
             alertType:(SRIMAlertType)type
               message:(nullable NSString *)message;

@end

@interface SRIMAlertExtension : NSObject

+ (instancetype)shareManager;

/** 是否需要开启提示功能 */
@property (nonatomic, assign) BOOL openAlert;

/** 代理 */
@property (nonatomic, weak) id<SRIMAlertExtensionDelegate> delegate;

- (void)alert:(SRIMAlertType)type message:(nullable NSString *)message;

@end

NS_ASSUME_NONNULL_END
