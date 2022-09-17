//
//  SRChatPrivateCell.h
//  addcnos
//
//  Created by addcnos on 2019/9/22.
//  Copyright © 2019 addcnos All rights reserved.
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
