//
//  SRChatImageCell.m
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/11/6.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRChatImageCell.h"
#import "SRChatImageCellViewModel.h"
#import "SRImageContent.h"
#import "SRIMUtility.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SRIMImageExtension.h"

@implementation SRChatImageCell

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

- (void)imageClicked {
    if (self.imageBlock) {
        self.imageBlock(self.cellViewModel);
    }
}

- (void)setCellViewModel:(SRChatImageCellViewModel *)cellViewModel {
    _cellViewModel = cellViewModel;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:cellViewModel.avatar] placeholderImage:[SRIMImageExtension imageWithName:@"chat_header"]];
    self.timeLabel.text = [cellViewModel.chatModel send_time];
    SRImageContent *imageContent = (SRImageContent *)[[cellViewModel chatModel] content];
    [self.imageContentView sd_setImageWithURL:[NSURL URLWithString:imageContent.thumbnail_url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CGSize imageSize = image.size;
//        NSLog(@"imageSize:%@-%zi", NSStringFromCGSize(imageSize), cacheType);
        if (imageSize.height < 50) {
            imageSize = CGSizeMake(imageSize.width, 50);
        }
        NSInteger message_direction = [cellViewModel.chatModel message_direction];
        if (message_direction == 1) {
            [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.timeLabel.mas_bottom).with.offset(5);
                make.right.mas_equalTo(self.contentView.mas_right).with.offset(-10);
                make.size.mas_equalTo(CGSizeMake(45, 45));
            }];
            [self.imageContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.avatarImageView);
                make.right.mas_equalTo(self.avatarImageView.mas_left).with.offset(-5);
                make.size.mas_equalTo(imageSize);
            }];
            [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.imageContentView.mas_left).with.offset(-10);
                make.centerY.equalTo(self.imageContentView);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
            [self.errorBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.imageContentView.mas_left).with.offset(-10);
                make.centerY.equalTo(self.imageContentView);
            }];
        }
        else if(message_direction == 2) {
            [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.timeLabel.mas_bottom).with.offset(5);
                make.left.mas_equalTo(self.contentView.mas_left).with.offset(10);
                make.size.mas_equalTo(CGSizeMake(45, 45));
            }];
            
            [self.imageContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.avatarImageView);
                make.left.mas_equalTo(self.avatarImageView.mas_right).with.offset(5);
                make.size.mas_equalTo(imageSize);
            }];
            
            [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.imageContentView.mas_right).with.offset(10);
                make.centerY.equalTo(self.imageContentView);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
            
            [self.errorBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.imageContentView.mas_right).with.offset(10);
                make.centerY.equalTo(self.imageContentView);
            }];
        }
        [self.imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-10);
        }];
        [self reloadImageView];
    }];
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

- (void)reloadImageView {
    UITableView *tableView = (UITableView *)self.superview;
    if ([tableView isKindOfClass:[UITableView class]]) {
        [tableView beginUpdates];
        [tableView endUpdates];
    }
}

- (void)setupContentView {
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.indicatorView];
    [self.contentView addSubview:self.errorBtn];
    [self.contentView addSubview:self.imageContentView];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(5);
        make.centerX.equalTo(self.contentView);
    }];
}

#pragma mark - Getter

- (UIImageView *)imageContentView {
    if (!_imageContentView) {
        _imageContentView = [[UIImageView alloc] init];
        _imageContentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked)];
        [_imageContentView addGestureRecognizer:tapGR];
    }
    return _imageContentView;
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
