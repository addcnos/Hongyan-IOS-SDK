//
//  SRChatPrivateCell.m
//  HKHouse591
//
//  Created by shuxiao on 2019/9/22.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRChatPrivateCell.h"
#import "SRIMUtility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SRIMImageExtension.h"
#import "SRIMConfigure.h"
@implementation SRChatPrivateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor = SRIMRGB(233, 233, 233);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupContentView];
        [self.errorBtn setHidden:YES];
    }
    return self;
}

- (void)setupContentView {
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.indicatorView];
    [self.contentView addSubview:self.errorBtn];
    [self.contentView addSubview:self.contentBGView];
    [self.contentBGView addSubview:self.attributeTextLabel];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(5);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_bottom).with.offset(10);
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];

    [self.contentBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarImageView.mas_top);
        make.left.mas_equalTo(self.avatarImageView.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(47, 40));
    }];

    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentBGView.mas_right).with.offset(25);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.errorBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(self.indicatorView);
        make.size.equalTo(self.indicatorView);
    }];
    
    [self.attributeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentBGView);
        make.left.mas_equalTo(self.contentBGView.mas_left).with.offset(10);
        make.right.mas_equalTo(self.contentBGView.mas_right).with.offset(-8);
    }];
}

#pragma mark - cellViewModel

- (void)setCellViewModel:(SRChatPrivateCellViewModel *)cellViewModel {
    SRIMConfigure *configure = [SRIMConfigure shareConfigure];
    _cellViewModel = cellViewModel;
    
    self.timeLabel.text = [cellViewModel sendTime];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:cellViewModel.avatar] placeholderImage:[SRIMImageExtension imageWithName:@"chat_header"]];
    NSString *contentStr = [cellViewModel contentString];
    NSInteger message_direction = [cellViewModel message_direction];
    UIColor *titleColor;
    if (message_direction == 1) {
        titleColor = configure.chat_to_title_color ? configure.chat_to_title_color : SRIMColorFromRGB(0xffffff);
    }else{
        titleColor = configure.chat_from_title_color ?  configure.chat_from_title_color : SRIMColorFromRGB(0x222222);
    }
    
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:contentStr attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15],NSForegroundColorAttributeName:titleColor}];
    
    self.attributeTextLabel.linkAttributes = @{NSForegroundColorAttributeName : SRIMRGB(28, 164, 252), NSUnderlineStyleAttributeName :@(NSUnderlineStyleSingle) ,NSUnderlineColorAttributeName:SRIMRGB(28, 164, 252)};
    self.attributeTextLabel.activeLinkAttributes = @{NSForegroundColorAttributeName : SRIMRGB(28, 164, 252), NSUnderlineStyleAttributeName :@(NSUnderlineStyleSingle), NSUnderlineColorAttributeName:SRIMRGB(28, 164, 252)};
    [self.attributeTextLabel setText:attributeString];
    
    
    if (message_direction == 1) {
        //发送的消息
        [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLabel.mas_bottom).with.offset(5);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        [self.contentBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView);
            make.right.mas_equalTo(self.avatarImageView.mas_left).with.offset(-5);
            make.width.mas_equalTo([cellViewModel contentWidth]);
            make.bottom.mas_equalTo(self.attributeTextLabel.mas_bottom).with.offset(10);
        }];
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentBGView.mas_left).with.offset(-10);
            make.centerY.equalTo(self.contentBGView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        [self.errorBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentBGView.mas_left).with.offset(-10);
            make.centerY.equalTo(self.contentBGView);
            
        }];
        [self.attributeTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentBGView.mas_right).with.offset(-12);
            make.centerY.equalTo(self.contentBGView);
            make.left.mas_equalTo(self.contentBGView.mas_left).with.offset(8);
        }];
        
    }
    else if (message_direction == 2) {
        //接收的消息
        [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLabel.mas_bottom).with.offset(5);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        
        [self.contentBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.avatarImageView);
            make.left.mas_equalTo(self.avatarImageView.mas_right).with.offset(5);
            make.bottom.mas_equalTo(self.attributeTextLabel.mas_bottom).with.offset(10);
        }];
        
        [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentBGView.mas_right).with.offset(10);
            make.centerY.equalTo(self.contentBGView);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [self.errorBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentBGView.mas_right).with.offset(10);
            make.centerY.equalTo(self.contentBGView);
        }];
        
        [self.attributeTextLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentBGView);
            make.left.mas_equalTo(self.contentBGView.mas_left).with.offset(12);
            make.right.mas_equalTo(self.contentBGView.mas_right).with.offset(-8);
        }];
    }
    [self.contentBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo([cellViewModel contentWidth]);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-5);
    }];
    
    if (message_direction == 1) {
        UIImage *bgImage = [SRIMImageExtension imageWithName:configure.chat_to_bg ? configure.chat_to_bg : @"sr_chat_to_bg_normal_1"];
        UIImage *stretchImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(bgImage.size.width / 2.0, bgImage.size.height / 2.0, bgImage.size.width / 2.0, bgImage.size.height / 2.0) resizingMode:UIImageResizingModeStretch];
        self.contentBGView.image = stretchImage;
        
    }
    else if (message_direction == 2) {
        UIImage *bgImage = [SRIMImageExtension imageWithName:configure.chat_from_bg ? configure.chat_from_bg : @"sr_chat_from_bg_normal_1"];
        UIImage *stretchImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(bgImage.size.width / 2.0, bgImage.size.height / 2.0, bgImage.size.width / 2.0 - 1, bgImage.size.height / 2.0 - 1) resizingMode:UIImageResizingModeStretch];
        self.contentBGView.image = stretchImage;
        
    }

    if (cellViewModel.chatModel.sendStatus == SRIMMessageSendStatusArrival) {
        [self stopIndicatorAnimatingWithMessageStatus:YES];
    }
    else if (cellViewModel.chatModel.sendStatus == SRIMMessageSendStatusFailure) {
        [self stopIndicatorAnimatingWithMessageStatus:NO];
    }
    else {
        [self startIndicatorAnimating];
    }
}

- (UIImageView *)contentBGView {
    if (!_contentBGView) {
        _contentBGView = [[UIImageView alloc] init];
        _contentBGView.image = [SRIMImageExtension imageWithName:@"sr_chat_from_bg_normal"];
        _contentBGView.userInteractionEnabled = YES;
    }
    return _contentBGView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = SRIMRGB(99, 99, 99);
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

- (TTTAttributedLabel *)attributeTextLabel {
    if (!_attributeTextLabel) {
        _attributeTextLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _attributeTextLabel.font = [UIFont systemFontOfSize:15];
        _attributeTextLabel.textColor = SRIMRGB(99, 99, 99);
        _attributeTextLabel.numberOfLines = 0;
//        _attributeTextLabel.lineSpacing = 5.f;
        _attributeTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _attributeTextLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
