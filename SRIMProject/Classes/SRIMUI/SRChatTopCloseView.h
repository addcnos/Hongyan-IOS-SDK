//
//  SRChatTopCloseView.h
//  AFNetworking
//
//  Created by zhengzeqin on 2019/12/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRChatTopCloseView : UIView
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, strong) void(^closeActionBlock)(void);
@end

NS_ASSUME_NONNULL_END
