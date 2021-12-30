//
//  SRIMEmojiCell.m
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/12/12.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRIMEmojiCell.h"
#import "SRIMConfigure.h"

@implementation SRIMEmojiCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *color = [SRIMConfigure shareConfigure].chat_detail_emojiKeyBoard_item_bg_color;
        self.contentView.backgroundColor = color ? color : [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1.0];
        [self setupContentView];
    }
    return self;
}

- (void)setEmoji:(NSString *)emoji {
    _emoji = emoji;
    self.emojiLabel.text = emoji;
}

- (void)setupContentView {
    [self.contentView addSubview:self.emojiLabel];
//    [self.emojiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
//    }];
}

- (UILabel *)emojiLabel {
    if (!_emojiLabel) {
        _emojiLabel = [[UILabel alloc] initWithFrame:self.contentView.frame];
        _emojiLabel.textAlignment = NSTextAlignmentCenter;
        _emojiLabel.font = [UIFont systemFontOfSize:20];
    }
    return _emojiLabel;
}

@end
