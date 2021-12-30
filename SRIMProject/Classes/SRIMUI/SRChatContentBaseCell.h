//
//  SRChatContentBaseCell.h
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/11/6.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
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
