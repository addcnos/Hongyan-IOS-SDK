//
//  SRConversationCell.h
//  HKHouse591
//
//  Created by addcn591 on 2019/9/20.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRConversationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRConversationCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avaterImageView;

@property (nonatomic, strong) UIView *bubbleView;

@property (nonatomic, strong) UILabel *bubbleLabel;

@property (nonatomic, strong) UILabel *nickNameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) SRConversationModel *conversation;

@end

NS_ASSUME_NONNULL_END
