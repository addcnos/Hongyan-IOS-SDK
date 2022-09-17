//
//  SRNotificationMessageView.h
//  addcnos
//
//  Created by addcnos on 2019/11/15.
//  Copyright © 2019 addcnos All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRNotificationMessageView : UIView
- (instancetype)initWithNickname:(NSString *)nickname message:(NSString *)message;
- (void)show;

@property (nonatomic, copy) void(^block)(SRNotificationMessageView *view);
@property (nonatomic, copy) void(^dissmissBlock)(SRNotificationMessageView *view);
@property (nonatomic, strong, readonly) UILabel *timeLabel;
@property (nonatomic, strong, readonly) UILabel *nameLabel;
@property (nonatomic, strong, readonly) UILabel *messageLabel;

/**
 設置文本內容
 
 @param message 消息
 @param name 暱稱
 */
- (void)reloadMessage:(NSString *)message name:(NSString*)name;
@end

NS_ASSUME_NONNULL_END
