//
//  SRConversationCell.m
//  addcnos
//
//  Created by addcnos on 2019/9/20.
//  Copyright © 2019 addcnos All rights reserved.
//

#import "SRConversationCell.h"
#import "SRChatContent.h"
#import "SRHouseContent.h"
#import "SRImageContent.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SRIMUtility.h"
#import "SRIMConsts.h"
#import "SRIMImageExtension.h"
#import "SRIMConfigure.h"
@implementation SRConversationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupContentView];
    }
    return self;
}

- (void)setConversation:(SRConversationModel *)conversation {
    _conversation = conversation;
    if (conversation.conversationType == SRConversationTypePrivate) {
        SRConversationChatModel *chatModel = conversation.chatModel;
        [self.avaterImageView sd_setImageWithURL:[NSURL URLWithString:chatModel.avatar] placeholderImage:[SRIMImageExtension imageWithName:@"chat_header"]];
        self.nickNameLabel.text = chatModel.nickname;
        self.timeLabel.text = chatModel.last_time;
        self.bubbleView.hidden = YES;
        if (chatModel.new_msg_count) {
            self.bubbleLabel.hidden = NO;
            self.bubbleLabel.text = [NSString stringWithFormat:@"%zi", chatModel.new_msg_count];
        }
        else {
            self.bubbleLabel.hidden = YES;
        }
        NSString *type = chatModel.type;
        if ([type isEqualToString:SRIMMessageTypeTxt]) {
            SRChatContent *chatContent = (SRChatContent *)chatModel.content;
            self.contentLabel.text = chatContent.content;
        }
        else if ([type isEqualToString:SRIMMessageTypeCustom]) {
            SRHouseContent *houseContent = (SRHouseContent *)chatModel.content;
            self.contentLabel.text = houseContent.shareContent;
        }
        else if ([type isEqualToString:SRIMMessageTypeImg]) {
            self.contentLabel.text = @"[圖片]";
        }
    }
    
}

- (void)setupContentView {
    if ([SRIMConfigure shareConfigure].chat_list_item_bg_color) {
        self.backgroundColor = [SRIMConfigure shareConfigure].chat_list_item_bg_color;
    }
    [self.contentView addSubview:self.avaterImageView];
    [self.contentView addSubview:self.bubbleView];
    [self.contentView addSubview:self.bubbleLabel];
    [self.contentView addSubview:self.nickNameLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.timeLabel];
    
    [self.avaterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).with.offset(10);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(45);
    }];
    
    [self.bubbleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avaterImageView.mas_top).with.offset(-4);
        make.left.mas_equalTo(self.avaterImageView.mas_right).with.offset(-4);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    [self.bubbleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avaterImageView.mas_top).with.offset(-8);
        make.left.mas_equalTo(self.avaterImageView.mas_right).with.offset(-8);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avaterImageView);
        make.left.mas_equalTo(self.avaterImageView.mas_right).with.offset(10);
        make.width.mas_equalTo(150);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.avaterImageView);
        make.left.equalTo(self.nickNameLabel);
        make.width.mas_equalTo(SRIMScreenWidth - 120);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avaterImageView);
        make.right.mas_equalTo(self.contentView.mas_right).with.offset(-10);
    }];
    
}

- (UIImageView *)avaterImageView {
    if (!_avaterImageView) {
        _avaterImageView = [[UIImageView alloc] init];
        _avaterImageView.layer.cornerRadius = 22.5;
        _avaterImageView.layer.masksToBounds = YES;
    }
    return _avaterImageView;
}

- (UIView *)bubbleView {
    if (!_bubbleView) {
        _bubbleView = [[UIView alloc] init];
        _bubbleView.backgroundColor = SRIMColorFromRGB(0xff0000);
        _bubbleView.layer.cornerRadius = 4;
        _bubbleView.layer.masksToBounds = YES;
    }
    return _bubbleView;
}

- (UILabel *)bubbleLabel {
    if (!_bubbleLabel) {
        _bubbleLabel = [[UILabel alloc] init];
        _bubbleLabel.backgroundColor = SRIMColorFromRGB(0xff0000);
        _bubbleLabel.layer.cornerRadius = 8;
        _bubbleLabel.layer.masksToBounds = YES;
        _bubbleLabel.textColor = [UIColor whiteColor];
        _bubbleLabel.font = [UIFont systemFontOfSize:9];
        _bubbleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bubbleLabel;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        UIColor *color = [SRIMConfigure shareConfigure].chat_list_item_nickNameLabel_color;
        _nickNameLabel.textColor = color ? color : [UIColor blackColor];
        _nickNameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _nickNameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        UIColor *color = [SRIMConfigure shareConfigure].chat_list_item_contentLabel_color;
        _contentLabel.textColor = color ? color : [UIColor colorWithRed:177 / 255.0 green:177 / 255.0 blue:177 / 255.0 alpha:1];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _contentLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        UIColor *color = [SRIMConfigure shareConfigure].chat_list_item_timeLabel_color;
        _timeLabel.textColor = color ? color : [UIColor colorWithRed:177 / 255.0 green:177 / 255.0 blue:177 / 255.0 alpha:1];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
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
