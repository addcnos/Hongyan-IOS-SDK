//
//  SRIMConfigure.h
//  AFNetworking
//
//  Created by zhengzeqin on 2019/12/20.
//  IM 样式配置单利对象

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRIMConfigure : NSObject
+ (instancetype)shareConfigure;
/// 背景色
@property (nonatomic, strong) UIColor *chat_bg_color;
/// 设置收的背景气泡
@property (nonatomic, copy) NSString *chat_from_bg;
/// 设置发的背景气泡
@property (nonatomic, copy) NSString *chat_to_bg;
/// 设置收的颜色值
@property (nonatomic, strong) UIColor *chat_from_title_color;
/// 设置发的颜色值
@property (nonatomic, strong) UIColor *chat_to_title_color;
/// 设置emoj delete
@property (nonatomic, copy) NSString *chat_emoji_delete;
/// 设置拍照
@property (nonatomic, copy) NSString *chat_take_photo;
/// 设置照片
@property (nonatomic, copy) NSString *chat_take_pic;
/// 设置emoji 发送的背景值
@property (nonatomic, strong) UIColor *chat_send_emoji_color;
/// 设置下标颜色
@property (nonatomic, strong) UIColor *chat_emoji_unsel_color;
/// 设置选中小标颜色
@property (nonatomic, strong) UIColor *chat_emoji_sel_color;
/// 设置文本边框颜色
@property (nonatomic, strong) UIColor *chat_textview_board_color;
@property (nonatomic, strong) UIColor *chat_inputBar_bg_color;
/// 输入框背景色
@property (nonatomic, strong) UIColor *chat_inputBar_inputTextView_bg_color;
/// 输入框边框颜色
@property (nonatomic, strong) UIColor *chat_inputBar_inputTextView_broder_color;

/// 列表页背景色
@property (nonatomic, strong, nullable) UIColor *chat_list_bg_color;
/// 列表页分割线的颜色
@property (nonatomic, strong, nullable) UIColor *chat_list_separator_color;
/// 列表页cell的背景颜色
@property (nonatomic, strong, nullable) UIColor *chat_list_item_bg_color;
/// 列表页cell中nickNameLabel的颜色
@property (nonatomic, strong, nullable) UIColor *chat_list_item_nickNameLabel_color;
/// 列表页cell中contentLabel的颜色
@property (nonatomic, strong, nullable) UIColor *chat_list_item_contentLabel_color;
/// 列表页cell中timeLabel的颜色
@property (nonatomic, strong, nullable) UIColor *chat_list_item_timeLabel_color;

/// 详情页聊天工具的背景色
@property (nonatomic, strong, nullable) UIColor *chat_detail_chatToolView_bg_color;
/// 详情页聊天工具cell的背景色
@property (nonatomic, strong, nullable) UIColor *chat_detail_chatToolView_item_bg_color;
/// 详情页聊天工具cell的标题颜色
@property (nonatomic, strong, nullable) UIColor *chat_detail_chatToolView_item_titleLabel_color;
/// 详情页emoji面板的背景色
@property (nonatomic, strong, nullable) UIColor *chat_detail_emojiKeyBoard_bg_color;
/// 详情页emoji面板cell的背景色
@property (nonatomic, strong, nullable) UIColor *chat_detail_emojiKeyBoard_item_bg_color;
/// 详情页cell中timeLabel的颜色
@property (nonatomic, strong, nullable) UIColor *chat_detail_item_timeLabel_color;
/// 详情页cell中userNameLabel的颜色
@property (nonatomic, strong, nullable) UIColor *chat_detail_item_userNameLabel_color;

@end

NS_ASSUME_NONNULL_END
