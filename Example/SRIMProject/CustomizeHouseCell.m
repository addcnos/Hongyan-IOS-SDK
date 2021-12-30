//
//  CustomizeHouseCell.m
//  SRIMProject_Example
//
//  Created by Addcnhk591 on 2019/12/30.
//  Copyright © 2019 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
//

#import "CustomizeHouseCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation CustomizeHouseCell

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

- (void)setCellViewModel:(SRIMBaseCellViewModel *)cellViewModel {
    _cellViewModel = cellViewModel;
    CustomizeHouseModel *houseModel = (CustomizeHouseModel *)cellViewModel.chatModel.content;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:cellViewModel.avatar]];
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:houseModel.icon]];
    self.title.text = SRIMNullClass(houseModel.title);
    self.address.text = SRIMNullClass(houseModel.address);
    self.price.text = SRIMNullClass(houseModel.price);
    self.price_unit.text = SRIMNullClass(houseModel.price_unit);
    NSInteger message_direction = cellViewModel.chatModel.message_direction;
    if (message_direction == 1) {
        [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLabel.mas_bottom).with.offset(5);
            make.right.mas_equalTo(self.contentView.mas_right).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        [self.contentBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImageView.mas_top).with.offset(5);
            make.right.mas_equalTo(self.avatarImageView.mas_left).with.offset(-5);
            make.size.mas_equalTo(CGSizeMake(220, 215));
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
    }
    else if (message_direction == 2) {
        [self.avatarImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.timeLabel.mas_bottom).with.offset(5);
            make.left.mas_equalTo(self.contentView.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
        [self.contentBGView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarImageView.mas_top).with.offset(5);
            make.left.mas_equalTo(self.avatarImageView.mas_right).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(220, 215));
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
    }
    [self.contentBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView.mas_bottom).with.offset(-5);
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

- (void)contentBGTapAction {
    
}

- (void)setupContentView {
    
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.indicatorView];
    [self.contentView addSubview:self.errorBtn];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(0);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(self.contentView).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    //內容
    UIView *contentBGView = [[UIView alloc] init];
    contentBGView.backgroundColor = SRIMColorFromRGB(0xffffff);
    contentBGView.layer.cornerRadius = 3.0;
    contentBGView.layer.masksToBounds = YES;
    self.contentBGView = contentBGView;
    [self.contentView addSubview:self.contentBGView];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentBGTapAction)];
    [self.contentBGView addGestureRecognizer:tapGR];
    
    //封面圖片
    UIImageView *coverView = [[UIImageView alloc] init];
    [self.contentBGView addSubview:coverView];
    self.coverView = coverView;
    
    //附加內容
    UIView *extraView = [[UIView alloc] init];
    [self.contentBGView addSubview:extraView];
    
    //標題
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:15];
    title.numberOfLines = 1;
    title.contentMode = UIViewContentModeTop;
    [extraView addSubview:title];
    self.title = title;
    
    //格局 - 坪數
    UILabel *address = [[UILabel alloc] init];
    address.font = [UIFont systemFontOfSize:13];
    address.textColor = SRIMColorFromRGB(0x999999);
    [extraView addSubview:address];
    self.address = address;
    
    //價格
    UILabel *price = [[UILabel alloc] initWithFrame:CGRectZero];
    price.font = [UIFont systemFontOfSize:14];
    price.textColor = SRIMColorFromRGB(0xff6600);
    [extraView addSubview:price];
    self.price = price;
    
    //單位
    UILabel *price_unit = [[UILabel alloc] initWithFrame:CGRectZero];
    price_unit.font = [UIFont systemFontOfSize:12];
    price_unit.textColor = SRIMColorFromRGB(0xff6600);
    [extraView addSubview:price_unit];
    self.price_unit = price_unit;
    
    [self.contentBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(220, 215));
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
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentBGView);
        make.height.equalTo(@165);
    }];
    [extraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverView.mas_bottom);
        make.left.right.equalTo(self.coverView);
        make.height.equalTo(@50);
    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(extraView).offset(5);
        make.left.equalTo(extraView).offset(5);
        make.right.equalTo(extraView);
    }];
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(extraView).offset(-5);
        make.left.equalTo(self.title);
    }];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(extraView).offset(-5);
        make.right.equalTo(self.price_unit.mas_left).offset(-2);
    }];
    [self.price_unit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.price);
        make.right.equalTo(extraView).offset(-5);
    }];
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
