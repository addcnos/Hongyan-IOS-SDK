//
//  SRChatPrivateCell.h
//  HKHouse591
//
//  Created by shuxiao on 2019/9/22.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRChatContentBaseCell.h"
#import "SRChatPrivateCellViewModel.h"
#import <TTTAttributedLabel/TTTAttributedLabel.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRChatPrivateCell : SRChatContentBaseCell

@property (nonatomic, strong) UIImageView *contentBGView;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) TTTAttributedLabel *attributeTextLabel;

@property (nonatomic, strong) SRChatPrivateCellViewModel *cellViewModel;

@end

NS_ASSUME_NONNULL_END
