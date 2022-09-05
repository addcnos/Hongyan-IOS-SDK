//
//  SRChatListExampleIndividualCell.m
//  SRIMProject_Example
//
//  Created by addcnos on 2019/12/18.
//  Copyright © 2019 addcnos. All rights reserved.
//

#import "SRChatListExampleIndividualCell.h"
#import <SRIMProject/SRIMProject.h>
#import "RemindMessageModel.h"

@implementation SRChatListExampleIndividualCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.errorBtn setHidden:YES];
    }
    return self;
}

- (void)setRemindModel:(RemindMessageModel *)remindModel {
    _remindModel = remindModel;
    self.userNameLabel.text = remindModel.remindStr;
    self.timeLabel.text = remindModel.time;
}

- (void)contentBGTapAction {
    if (self.block) {
        self.block();
    }
}

- (void)setupView {
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).with.offset(0);
        make.centerX.equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.timeLabel.mas_top).with.offset(20);
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
