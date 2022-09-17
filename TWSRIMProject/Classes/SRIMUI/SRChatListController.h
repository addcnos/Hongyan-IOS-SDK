//
//  SRChatListController.h
//  addcnos
//
//  Created by addcnos on 2019/9/20.
//  Copyright © 2019 addcnos All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRBaseContentModel.h"
@class SRConversationModel, SRConversationCell;
NS_ASSUME_NONNULL_BEGIN

@interface SRChatListController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, readonly) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

/// 即将加载列表数据源的回调
/// @param dataSource 即将加载的列表数据源（元素为SRConversationModel对象）
/// @return 修改后的数据源（元素为SRConversationModel对象）
/// @discussion 您可以在回调中修改、添加、删除数据源的元素来定制显示的内容，会话列表会根据您返回的修改后的数据源进行显示。
/// 数据源中存放的元素为会话Cell的数据模型，即SRConversationModel对象。
- (NSMutableArray *)willReloadTableViewDataSource:(NSMutableArray *)dataSource;

//加载到数据是空的
- (void)finishLoadData:(BOOL)isEmpty;

//错误的加载
- (void)failureLoadData:(NSError *)error;

// 加載聊天列表
- (void)fetchDataSource;
// 上拉加载更多
- (void)loadMoreDataSource;

//结束刷新
- (void)endRefreshing;

/// 用于将返回的自定义消息JsonDic数据转换成自定义Model
/// @param contentDic 自定义消息体json字典
- (SRBaseContentModel *)propertiesWithKeyValues:(NSDictionary *)contentDic;

/// 即将显示Cell的回调
/// @param cell 即将显示的Cell
/// @param indexPath 该Cell对应的会话Cell数据模型在数据源中的索引值
/// @discussion 您可以在此回调中修改Cell的一些显示属性。
- (void)willDisplayConversationTableCell:(SRConversationCell *)cell atIndexPath:(NSIndexPath *)indexPath;

/// 子类重写此方法，用于自定制会话Cell的UI显示
/// @param cell 会话Cell
/// @param conversationModel 会话Model
/// @param indexPath 会话下标
- (void)configureCell:(SRConversationCell *)cell withModel:(SRConversationModel *)conversationModel forRowAtIndexPath:(NSIndexPath *)indexPath;

/// 子类重写此方法，控制会话能否被编辑
/// @param conversationModel 会话Model
/// @param indexPath 下标
- (BOOL)canEditForTableViewModel:(SRConversationModel *)conversationModel rowAtIndexPath:(NSIndexPath *)indexPath;

/// 子类重写此方法，控制会话编辑类型
/// @param conversationModel 会话Model
/// @param indexPath 会话下标
- (UITableViewCellEditingStyle )editingStyleForConversationModel:(SRConversationModel *)conversationModel rowAtIndexPath:(NSIndexPath *)indexPath;

/// 子类重写此方法，控制编辑按钮数量和对应的点击逻辑
/// @param conversationModel 会话Model
/// @param indexPath 会话下标
- (NSArray *)editActionsForConversationModel:(SRConversationModel *)conversationModel rowAtIndexPath:(NSIndexPath *)indexPath;

/// 点击聊天列表中Cell的回调
/// @param conversationModel 当前点击的会话的Model
/// @param indexPath 当前会话在列表数据源中的索引值
- (void)onSelectedTableViewModel:(SRConversationModel *)conversationModel
               forRowAtIndexPath:(NSIndexPath *)indexPath;

/// Cell状态更新回调
/// @param indexPath 该Cell对应的会话Cell数据模型在数据源中的索引值
/// @discussion 当Cell的阅读状态等信息发生改变时的回调，您可以在此回调中更新Cell的显示。
- (void)updateCellAtIndexPath:(NSIndexPath *)indexPath;

/*!
 在会话列表中，收到新消息的回调
 
 @param notify    收到新消息的notification
 
 @discussion SDK在此方法中有针对消息接收有默认的处理（如刷新等），如果您重写此方法，请注意调用super。
 
 notification的userInfo为新消息NSDictionary对象
 */
- (void)receiveMessageNotification:(NSNotification *)notify;

@end

NS_ASSUME_NONNULL_END
