//
//  SRChatContentBaseCell.h
//  addcnos
//
//  Created by addcnos on 2019/11/6.
//  Copyright © 2019 addcnos All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRChatCellDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRChatContentBaseCell : UITableViewCell

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UIButton *errorBtn;

@property (nonatomic, strong) UIImageView *avatarImageView;

@property (nonatomic, strong) UILabel *userNameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, weak) id <SRChatCellDelegate> delegate;

- (void)stopIndicatorAnimatingWithMessageStatus:(BOOL )status;
- (void)startIndicatorAnimating;
@end

NS_ASSUME_NONNULL_END
