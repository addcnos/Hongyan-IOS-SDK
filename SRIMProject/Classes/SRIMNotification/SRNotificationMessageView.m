//
//  SRNotificationMessageView.m
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/11/15.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRNotificationMessageView.h"
#import "SRIMUtility.h"

@interface SRNotificationMessageView ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation SRNotificationMessageView

- (void)dealloc{
    SRIMLog(@"SRNotificationMessageView delloc = %p",self);
}

- (instancetype)initWithNickname:(NSString *)nickname message:(NSString *)message {
    if (self = [super init]) {
        self.frame = CGRectMake(10, -70, SRIMScreenWidth - 20, 70);
        self.backgroundColor = [UIColor colorWithWhite:250 / 255.0 alpha:1.f];
        self.layer.cornerRadius = 8.f;
        self.layer.shadowOffset = CGSizeMake(0,2);
        self.layer.shadowOpacity = 1;
        self.layer.shadowColor = SRIMRGB(51, 51, 51).CGColor;
        self.layer.shadowRadius = 5;
        //        self.layer.masksToBounds = YES;
        [self setupView];
        [self reloadMessage:message name:nickname];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageViewTapped)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)messageViewTapped {
    if (self.block) {
        self.transform = CGAffineTransformIdentity;
        //        [self removeFromSuperview];
        self.block(self);
    }
}

- (void)show {
    if (!self.superview) {
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view bringSubviewToFront:self];
    }
    if (self.frame.origin.y > 0) {
        self.transform = CGAffineTransformIdentity;
        [self show];
    }
    else {
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformMakeTranslation(0, 70 + [self statusBarHeight]);
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    self.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                    if (self.dissmissBlock) {
                        self.dissmissBlock(self);
                    }
                }];
            });
        }];
    }
}

- (void)reloadMessage:(NSString *)message name:(NSString*)name{
    if (SRIMIsStrClass(message) && SRIMIsStrClass(name)) {
        self.nameLabel.text = name;
        self.messageLabel.text = message;
    }
}

- (void)setupView {
    [self addSubview:self.nameLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:self.messageLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(10);
        make.left.mas_equalTo(self.mas_left).with.offset(10);
        make.right.mas_lessThanOrEqualTo(self.timeLabel.mas_left);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel);
        make.right.mas_equalTo(self.mas_right).with.offset(-10);
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.nameLabel);
        make.right.equalTo(self.timeLabel);
    }];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = SRIMRGB(51, 51, 51);
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _nameLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = SRIMRGB(102, 102, 102);
        _messageLabel.font = [UIFont systemFontOfSize:16];
    }
    return _messageLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"現在";
        _timeLabel.textColor = SRIMRGB(144, 144, 144);
        _timeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _timeLabel;
}

- (CGFloat )statusBarHeight {
    return [self isiPhoneX] ? 44 : 20;
}

- (BOOL)isiPhoneX {
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        // 获取底部安全区域高度，iPhone X 竖屏下为 34.0，横屏下为 21.0，其他类型设备都为 0
        CGFloat bottomSafeInset = keyWindow.safeAreaInsets.bottom;
        if (bottomSafeInset == 34.0f || bottomSafeInset == 21.0f) {
            return YES;
        }
    }
    return NO;
}

@end
