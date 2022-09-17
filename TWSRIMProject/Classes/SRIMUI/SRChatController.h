//
//  SRChatController.h
//  addcnos
//
//  Created by addcnos on 2019/9/22.
//  Copyright © 2019 addcnos All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRConversationModel.h"
#import "SRChatContentBaseCell.h"
#import "SRChatModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SRChatController : UIViewController

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, strong) UIView *inputBarView;

@property (nonatomic, strong) UITextView *inputTextView;

@property (nonatomic, assign, readonly) CGFloat inputBarHeight;

/// 聊天记录数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

/// 对方的IM信息
@property (nonatomic, copy, readonly) NSDictionary *targetInfo;

/**
 动态设置view高度默认是view高度
 */
@property (nonatomic, assign) CGFloat viewHeight;

/**
 是否显示顶部关闭按钮
 */
@property (nonatomic, assign) BOOL showTopCloseView;

/**
 是否设置为已读
 */
@property (nonatomic, assign) BOOL isSetHadRead;

/** 对方的uid*/
@property (nonatomic, copy) NSString *target_uid;

/** 对方的昵称*/
@property (nonatomic, copy) NSString *target_name;

/** 更新导航栏返回按钮中显示的未读消息数*/
- (NSInteger )notifyUpdateUnreadMessageCount;

/// 发送消息
/// @param chatContent 文本/物件/图片等消息模型
- (void)sendCustomMessage:(SRBaseContentModel *)chatContent;

/// 个资提醒/自动回复
/// 在会话页面中插入一条消息并展示
/// @param chatContent 消息实体（用于打招呼/个资提醒等本地消息）
/// @discussion 通过此方法插入一条消息，会将消息实体对应的内容Model插入数据源中，并更新UI。
/// 请注意，这条消息只会在 UI 上插入，并不会发送给对方。
/// 用户调用这个接口插入消息之后，如果退出会话页面再次进入的时候，这条消息将不再显示。

- (void)appendAndDisplayMessage:(SRBaseContentModel *)chatContent;

/// 自定义类型消息发送完成，子类重写以用于自定义消息发送完成后做其他的操作
- (void)sendCustomMessageFinished;

/// 用于文本消息Cell中的消息内容添加交互事件(如超链接点击等)
/// @param cell SRChatContentBaseCell
/// @param contentStr 消息文本内容
- (void)configureCell:(SRChatContentBaseCell *)cell text:(NSString *)contentStr;

/// 用于将返回的自定义消息JsonDic数据转换成自定义Model
/// @param contentDic 自定义消息体json字典
- (SRBaseContentModel *)propertiesWithKeyValues:(NSDictionary *)contentDic;

/// 即将显示消息Cell的回调
/// @param cell 消息cell
/// @param indexPath 该Cell对应的消息Cell数据模型在数据源中的索引值
- (void)willDisplayMessageCell:(SRChatContentBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/// 注册自定义消息的Cell
/// @param cellClass 自定义消息Cell的类
/// @param messageClass 自定义消息Cell对应的自定义消息的类，该自定义消息需要继承自SRBaseContentModel
/// discussion 你需要在cell中重写
- (void)registerCellClass:(Class )cellClass forMessageClass:(Class )messageClass;


/// 自定义消息Cell显示的回调
/// @param tableView 当前tableView
/// @param indexPath 该Cell对应的自定义消息数据模型在数据源中的索引值
/// @return          自定义消息需要显示的Cell
/// 自定义消息如果需要显示，则必须先通过SRIM的registerCellClass:注册该自定义消息类型，
/// 并在会话页面中通过registerClass:forCellWithReuseIdentifier:注册该自定义消息的Cell，否则将此回调将不会被调用。
- (SRChatContentBaseCell *)srIMChatTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/// 自定义消息Cell显示的回调
/// @param tableView 当前tableView
/// @param indexPath 该Cell对应的自定义消息数据模型在数据源中的索引值
/// @return          自定义消息Cell需要显示的高度
/// 自定义消息如果需要显示，则必须先通过SRIM的registerCellClass:注册该自定义消息类型，
/// 并在会话页面中通过registerClass:forCellWithReuseIdentifier:注册该自定义消息的Cell，否则将此回调将不会被调用。
- (CGFloat )srIMChatTableView:(UITableView *)tableView sizeForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 发送消息成功与否的刷新tableView
 
 @param status 状态
 @param indexPath indexPath
 */
- (void)reloadMessageSendStatus:(SRIMMessageSendStatus )status ForIndexPath:(NSIndexPath *)indexPath;


/// 发送消息的url
- (NSString *)getSendMessageUrl;
/// 发送消息扩展字段
- (NSDictionary *)getSendMessageExtDic;
/// 发送消息回调
- (void)postMessageResult:(NSDictionary *)json;
#pragma mark - 点击事件回调

/// 点击Cell消息内容的回调
/// @param model 消息Cell的数据模型
- (void)didTapCustomizeCell:(SRBaseContentModel *)model;

/// 点击Cell中URL的回调
/// @param url 点击的URL
- (void)didTapUrlInChatCell:(NSString *)url;

/// 点击Cell中电话号码的回调
/// @param phoneNumber 点击的电话号码
- (void)didTapPhoneNumberInChatCell:(NSString *)phoneNumber;

/// 点击Cell中图片的回调
/// @param imageUrls 当前已拉取到的聊天记录中图片URL数组
/// @param index 点击的ImageCell在数据源中的索引
//- (void)presentImagePreviewController:(NSMutableArray *)imageUrls forRowAtIndex:(NSInteger)index;


/**
 显示当前点击图片
 */
- (void)presentImagePreviewCurrent:(NSString *)imageUrl;

/**
 将要发送的方法调用
 
 @param dic 发送内容
 */
- (void)willSendingMsg:(NSDictionary *)dic;


/**
 获取历史数据
 */
- (void)historyMessageAction;
/**
 上传图片
 
 @param status 状态
 */
- (void)upLoadImgStatus:(SRIMMessageSendStatus)status;

/** 如果继承者有自定义的相册选择器，则需要重写此方法并实现具体的Present和Dismiss,此方法需与下面的uploadMultipleImages:completionBlock:搭配使用 */
- (void )photoImagePicker;

/// 多张图片上传接口
/// @param images 图片对象数组，元素必须为UIImage类型
/// @param completionBlock 上传完成回调
- (void)uploadMultipleImages:(NSArray <UIImage *> *)images completionBlock:(void (^)(void))completionBlock;

//加载到数据是空的
- (void)finishLoadData:(BOOL)isEmpty;

//错误的加载
- (void)failureLoadData:(NSError *)error;

/// 文本框视图起始高度发生变化
/// @param originY inputBarViewOriginY
- (void)inputBarViewOriginYChanged:(CGFloat )originY;

/// 收起当前处于编辑状态的工具栏View（如表情View或照片/拍摄）
- (void)hideToolButtons;
/// 收起键盘和InputView
- (void)hideKeyboardAndInputView;

#pragma mark - TableView
/// tableView section header 的 高度
- (CGFloat)heightForTableViewHeaderInSection:(NSInteger)section;
/// tableView section header 的 view
- (UIView *)viewForTableViewHeaderInSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
