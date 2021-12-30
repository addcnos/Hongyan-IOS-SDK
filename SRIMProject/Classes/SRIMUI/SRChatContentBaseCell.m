//
//  SRChatContentBaseCell.m
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/11/6.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRChatContentBaseCell.h"
#import "SRIMUtility.h"
#import "SRIMImageExtension.h"
#import "SRIMConfigure.h"
@interface SRChatContentBaseCell()
@property (nonatomic, strong) SRIMConfigure *configure;
@end
@implementation SRChatContentBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = self.configure.chat_bg_color ? self.configure.chat_bg_color : SRIMColorFromRGB(0xf5f5f5);
        [self setupView];
    }
    return self;
}

- (void)errorAction {
    UITableView *tableView = (UITableView *)self.superview;
    if ([tableView isKindOfClass:[UITableView class]]) {
        NSIndexPath *indexPath = [tableView indexPathForCell:self];
        [self startIndicatorAnimating];
        if (self.delegate && [self.delegate respondsToSelector:@selector(errorBtnEventForIndexPath:)]) {
            [self.delegate errorBtnEventForIndexPath:indexPath];
        }
    }
}

- (void)startIndicatorAnimating {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicatorView startAnimating];
        [self.errorBtn setHidden:YES];
    });
}

- (void)stopIndicatorAnimatingWithMessageStatus:(BOOL )status {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.indicatorView stopAnimating];
        [self.errorBtn setHidden:status];
    });
}

- (void)setupView {
    
}

- (SRIMConfigure *)configure{
    if (!_configure) {
        _configure = [SRIMConfigure shareConfigure];
    }
    return _configure;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = self.configure.chat_detail_item_timeLabel_color ? self.configure.chat_detail_item_timeLabel_color : SRIMRGB(144, 144, 144);
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UILabel *)userNameLabel {
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.textColor = self.configure.chat_detail_item_userNameLabel_color ? self.configure.chat_detail_item_userNameLabel_color : SRIMRGB(66, 66, 66);
        _userNameLabel.font = [UIFont systemFontOfSize:14];
        _userNameLabel.numberOfLines = 0;
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _userNameLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 22.5;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        if (@available(iOS 13.0, *)) {
            //UIActivityIndicatorViewStyleMedium
            _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        } else {
            _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
    return _indicatorView;
}

- (UIButton *)errorBtn {
    if (!_errorBtn) {
        _errorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_errorBtn setImage:[SRIMImageExtension imageWithName:@"message_send_error"] forState:UIControlStateNormal];
        [_errorBtn addTarget:self action:@selector(errorAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _errorBtn;
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
