//
//  SRChatToolCell.m
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/11/7.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRChatToolCell.h"
#import "SRIMUtility.h"
#import "SRIMConfigure.h"

@implementation SRChatToolCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.toolImageView];
        [self.contentView addSubview:self.toolTitleLabel];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        [self.toolImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.bgView);
        }];
        [self.toolTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bgView.mas_bottom).with.offset(5);
            make.centerX.equalTo(self.contentView);
        }];
    }
    return self;
}

#pragma mark - Getter

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        UIColor *color = [SRIMConfigure shareConfigure].chat_detail_chatToolView_item_bg_color;
        _bgView.backgroundColor = color ? color : [UIColor whiteColor];
        _bgView.layer.cornerRadius = 8.f;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UIImageView *)toolImageView {
    if (!_toolImageView) {
        _toolImageView = [[UIImageView alloc] init];
    }
    return _toolImageView;
}

- (UILabel *)toolTitleLabel {
    if (!_toolTitleLabel) {
        _toolTitleLabel = [[UILabel alloc] init];
        UIColor *color = [SRIMConfigure shareConfigure].chat_detail_chatToolView_item_titleLabel_color;
        _toolTitleLabel.textColor = color ? color : SRIMColorFromRGB(0x999999);
        _toolTitleLabel.font = [UIFont systemFontOfSize:12];
        _toolTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _toolTitleLabel;
}

@end
