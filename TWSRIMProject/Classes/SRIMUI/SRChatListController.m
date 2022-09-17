//
//  SRChatListController.m
//  addcnos
//
//  Created by addcnos on 2019/9/20.
//  Copyright © 2019 addcnos All rights reserved.
//

#import "SRChatListController.h"

#import "SRConversationCell.h"
#import "SRConversationModel.h"
#import "SRChatContent.h"
#import "SRHouseContent.h"
#import "SRImageContent.h"
#import "SRChatController.h"
#import "SRIMClient.h"
#import <PINCache/PINCache.h>
#import "SRIMUtility.h"
#import "SRIMURLDefine.h"
#import "SRIMNetworkManager.h"
#import <MJExtension/MJExtension.h>
#import "SRIMConsts.h"
#import "SRIMConfigure.h"
#import <MJRefresh/MJRefresh.h>
#import <TWSRIMProject/UIAlertController+ZQBlock.h>

@interface SRChatListController ()

@property (nonatomic, assign) BOOL hasMailPaper;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation SRChatListController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self) {
        self.pageIndex = 1;
        self.pageSize = 20;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configure];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageNotification:) name:SRIMDidReceiveChatMessageNotification object:nil];
    [self fetchDataSource];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SRIMDidReceiveChatMessageNotification object:nil];
}

- (void)configure{
    self.navigationItem.title = @"消息列表";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)setupView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)receiveMessageNotification:(NSNotification *)notify {
    NSDictionary *userInfo = notify.userInfo;
    NSString *type = userInfo[@"type"];
    if ([type isEqualToString:SRIMMessageTypeTxt] || [type isEqualToString:SRIMMessageTypeCustom] || [type isEqualToString:SRIMMessageTypeImg]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self fetchDataSource];
        });
    }
}

#pragma mark - prepareCustomMessageList
- (void)prepareCustomMessageList {
    
}

#pragma mark -- 加載聊天列表
- (void)fetchDataSource {
    self.pageIndex = 1;
    [self loadChatUsers];
}

#pragma mark -- 上拉加载更多
- (void)loadMoreDataSource {
    self.pageIndex += 1;
    [self loadChatUsers];
}

#pragma mark - API
//获取聊天列表数据
- (void)loadChatUsers {
    if (self.pageIndex == 1) { // 重置mj_footer的状态
        [self resetNoMoreData];
    }
    NSString *url = SRIMConversationList;
    NSString *token = [[SRIMClient shareClient] getToken];
    NSDictionary *param = @{@"page": @(self.pageIndex), @"limit": @(self.pageSize), @"token": token};
    [[SRIMNetworkManager shareManager] loadDataWithUrl:url method:@"GET" parameters:param success:^(id  _Nonnull responseObject) {
        SRIMLog(@"pageIndex:%zi chat users: %@", self.pageIndex, responseObject);
        NSInteger totalUsers = [[responseObject objectForKey:@"total"] integerValue];
        NSArray *list = [responseObject objectForKey:@"data"];
        NSInteger currentPageCount = list.count;
        if (self.pageIndex == 1) {
            if (self.dataSource.count) {
                [self.dataSource removeAllObjects];
            }
            if (currentPageCount == self.pageSize) {
                [self.tableView.mj_footer resetNoMoreData];
            }
            else if (currentPageCount < self.pageSize){
                [self endRefreshingNoMoreData];
            }
        }
        else {
            if (currentPageCount < self.pageSize) {
                [self endRefreshingNoMoreData];
            }
        }
        
        if (list.count) {
            for (NSDictionary *conversation in list) {
                SRConversationModel *conversationModel = [[SRConversationModel alloc] init];
                conversationModel.conversationType = SRConversationTypePrivate;
                conversationModel.unreadMessageCount = [[conversation objectForKey:@"new_msg_count"] integerValue];
                SRConversationChatModel *chatModel = [SRConversationChatModel mj_objectWithKeyValues:conversation];
                NSString *conversationType = [conversation objectForKey:@"type"];
                if (SRIMIsDictionaryClass(conversation[@"content"])) {
                    if ([conversationType isEqualToString:SRIMMessageTypeTxt]) {
                        SRChatContent *chatContent = [SRChatContent mj_objectWithKeyValues:conversation[@"content"]];
                        chatModel.content = chatContent;
                    }
                    else if ([conversationType isEqualToString:SRIMMessageTypeCustom]) {
                        SRBaseContentModel *houseContent = [self propertiesWithKeyValues:conversation[@"content"]];
                        chatModel.content = houseContent;
                    }
                    else if ([conversationType isEqualToString:SRIMMessageTypeImg]) {
                        SRImageContent *imageContent = [SRImageContent mj_objectWithKeyValues:conversation[@"content"]];
                        chatModel.content = imageContent;
                    }
                }
                conversationModel.chatModel = chatModel;
                [self.dataSource addObject:conversationModel];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endRefreshing];
                if (self.pageIndex == 1) {
                    self.dataSource = [self willReloadTableViewDataSource:self.dataSource];
                }
                [self finishLoadData:NO];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self endRefreshing];
                if (self.pageIndex == 1) {
                    self.dataSource = [self willReloadTableViewDataSource:self.dataSource];
                }
                [self finishLoadData:YES];
            });
        }
        
    } failureBlock:^(NSError * _Nonnull error) {
        NSInteger code = error.code;
        if (code == 4006 || code == 4004) { // token失效了
            if ([SRIMClient.shareClient.delegate respondsToSelector:@selector(srIMClient:didReceiveErrorCode:)]) {
                [SRIMClient.shareClient.delegate srIMClient:SRIMClient.shareClient didReceiveErrorCode:code];
            }
        }
        if (self.pageIndex > 1) {
            self.pageIndex -= 1;
        }
        [self endRefreshing];
        if (self.pageIndex == 1) {
            self.dataSource = [self willReloadTableViewDataSource:self.dataSource];
        }
        [self failureLoadData:error];
    }];
}

//删除聊天对象
- (void)deleteChatPresonInfoTargetUid:(NSString *)target_uid {
    NSString *url = SRIMDelLiaisonPerson;
    NSString *token = [[SRIMClient shareClient] getToken];
    NSDictionary *param = @{@"target_uid": SRIMNullClass(target_uid), @"token": token};
    [[SRIMNetworkManager shareManager] loadDataWithUrl:url method:@"POST" parameters:param success:^(id  _Nonnull responseObject) {
        SRIMLog(@"deleteChatPresonInfoTargetUid:%@", responseObject);
    } failureBlock:^(NSError * _Nonnull error) {
        SRIMLog(@"deleteChatPresonInfoTargetUid: fail");
    }];
}

#pragma mark - Method
//结束刷新
- (void)endRefreshing{
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)endRefreshingNoMoreData{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    self.tableView.mj_footer.hidden = YES;
}

- (void)resetNoMoreData {
    [self.tableView.mj_footer resetNoMoreData];
    self.tableView.mj_footer.hidden = NO;
}

//错误的加载
- (void)failureLoadData:(NSError *)error{
    [self.tableView reloadData];
}

//请求完成加载
- (void)finishLoadData:(BOOL)isEmpty{
    [self.tableView reloadData];
}

- (NSMutableArray *)willReloadTableViewDataSource:(NSMutableArray *)dataSource {
    return dataSource;
}

- (SRBaseContentModel *)propertiesWithKeyValues:(NSDictionary *)contentDic {
    return [SRHouseContent mj_objectWithKeyValues:contentDic];
}

//设置已读
- (void)readMessageWithIndexPath:(NSIndexPath *)indexPath {
    SRConversationModel *conversationModel = self.dataSource[indexPath.row];
    SRConversationType conversationType = conversationModel.conversationType;
    if (conversationType == SRConversationTypePrivate) {
        SRConversationChatModel *chatModel = conversationModel.chatModel;
        NSString *target_uid = chatModel.uid;
        NSDictionary *params = @{@"token": [[SRIMClient shareClient] getToken], @"target_uid": target_uid};
        [[SRIMNetworkManager shareManager] loadDataWithUrl:SRIMReadTargetUserMessage method:@"POST" parameters:params success:^(id  _Nonnull responseObject) {
            NSDictionary *responseDic = (NSDictionary *)responseObject;
            SRIMLog(@"ReadMessage:%@", responseDic);
            chatModel.new_msg_count = 0;
            conversationModel.chatModel = chatModel;
            if (indexPath.row < self.dataSource.count) {
                [self.dataSource replaceObjectAtIndex:indexPath.row withObject:conversationModel];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            [self updateCellAtIndexPath:indexPath];
            [[NSNotificationCenter defaultCenter] postNotificationName:SRIMDidUpdateReadMessageNotification object:nil userInfo:nil];
        } failureBlock:^(NSError * _Nonnull error) {
            //
        }];
    }
}

- (void)updateCellAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSString *)timestampSwitchTime:(NSString *)timeStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSInteger timestamp = [timeStr integerValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [formatter stringFromDate:confromTimesp];
}

- (void)deletedCellIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSource.count > indexPath.row) {
        SRIMWeakSelf(weakSelf);
        [UIAlertController showAlertInViewController:self
                     withTitle:@"確定刪除"
                       message:@"聊天記錄一旦被刪除將無法恢復！是否刪除聊天記錄？"
             cancelButtonTitle:@"否"
        destructiveButtonTitle:@"是"
             otherButtonTitles:nil
                      tapBlock:^(UIAlertController *controller, UIAlertAction *action, NSInteger buttonIndex){
                            if (buttonIndex == controller.destructiveButtonIndex) {
                               SRConversationModel *conversationModel = weakSelf.dataSource[indexPath.row];
                               NSString *uid = conversationModel.chatModel.uid;
                               [weakSelf deleteChatPresonInfoTargetUid:uid];
                               [weakSelf.dataSource removeObjectAtIndex:indexPath.row];
                               [weakSelf.tableView reloadData];
                           }
                       }];

    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    SRConversationCell *conversationCell = (SRConversationCell *)cell;
    [self willDisplayConversationTableCell:conversationCell atIndexPath:indexPath];
}

- (void)willDisplayConversationTableCell:(SRConversationCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SRConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SRConversationCell class])];
    if (self.dataSource.count>indexPath.row) {
        SRConversationModel *conversationModel = self.dataSource[indexPath.row];
        if (conversationModel.conversationType == SRConversationTypePrivate) {
            cell.conversation = self.dataSource[indexPath.row];
        }
        else {
            [self configureCell:cell withModel:conversationModel forRowAtIndexPath:indexPath];
        }
    }else{
        SRIMLog(@"数组越界....需关注下....");
    }
    return cell;
}

/// 子类重写此方法，用于自定制会话Cell的UI显示
/// @param cell 会话Cell
/// @param conversationModel 会话Model
/// @param indexPath 会话下标
- (void)configureCell:(SRConversationCell *)cell withModel:(SRConversationModel *)conversationModel forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.conversation = conversationModel;
}

#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count) {
        return NO;
    }
    SRConversationModel *conversationModel = self.dataSource[indexPath.row];
    SRConversationType conversationType = conversationModel.conversationType;
    if (conversationType == SRConversationTypePrivate) {
        return YES;
    }
    else {
        return [self canEditForTableViewModel:conversationModel rowAtIndexPath:indexPath];
    }
}

/// 子类重写此方法，控制会话能否被编辑
/// @param conversationModel 会话Model
/// @param indexPath 下标
- (BOOL)canEditForTableViewModel:(SRConversationModel *)conversationModel rowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= self.dataSource.count) {
        return;
    }
    SRConversationModel *conversationModel = self.dataSource[indexPath.row];
    SRConversationType conversationType = conversationModel.conversationType;
    if (conversationType == SRConversationTypePrivate) {
        if (conversationModel.chatModel.new_msg_count) {
            [self readMessageWithIndexPath:indexPath];
        }
    }
    [self onSelectedTableViewModel:conversationModel forRowAtIndexPath:indexPath];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.dataSource.count) {
        return UITableViewCellEditingStyleNone;
    }
    SRConversationModel *conversationModel = self.dataSource[indexPath.row];
    SRConversationType conversationType = conversationModel.conversationType;
    if (conversationType == SRConversationTypePrivate) {
        return UITableViewCellEditingStyleDelete;
    }
    else {
        return [self editingStyleForConversationModel:conversationModel rowAtIndexPath:indexPath];
    }
}

/// 子类重写此方法，控制会话编辑类型
/// @param conversationModel 会话Model
/// @param indexPath 会话下标
- (UITableViewCellEditingStyle )editingStyleForConversationModel:(SRConversationModel *)conversationModel rowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    SRIMWeakSelf(weakSelf);
    if (indexPath.row >= self.dataSource.count) {
        return @[];
    }
    SRConversationModel *conversationModel = self.dataSource[indexPath.row];
    SRConversationType conversationType = conversationModel.conversationType;
    if (conversationType == SRConversationTypePrivate) {
        UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"刪除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            //删除
            [weakSelf deletedCellIndexPath:indexPath];
        }];
        return @[deleteRowAction];
    }
    else {
        return [self editActionsForConversationModel:conversationModel rowAtIndexPath:indexPath];
    }
}

/// 子类重写此方法，控制编辑按钮数量和对应的点击逻辑
/// @param conversationModel 会话Model
/// @param indexPath 会话下标
- (NSArray *)editActionsForConversationModel:(SRConversationModel *)conversationModel rowAtIndexPath:(NSIndexPath *)indexPath {
    return @[];
}

- (void)onSelectedTableViewModel:(SRConversationModel *)conversationModel
               forRowAtIndexPath:(NSIndexPath *)indexPath {
    SRChatController *chatController = [[SRChatController alloc] init];
    chatController.target_uid = conversationModel.chatModel.uid;
    chatController.target_name = conversationModel.chatModel.nickname;
    chatController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark - Getter

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.showsVerticalScrollIndicator = YES;
        if ([SRIMConfigure shareConfigure].chat_list_bg_color) {
            _tableView.backgroundColor = [SRIMConfigure shareConfigure].chat_list_bg_color;
        }
        if ([SRIMConfigure shareConfigure].chat_list_separator_color) {
            _tableView.separatorColor = [SRIMConfigure shareConfigure].chat_list_separator_color;
        }
        [_tableView registerClass:[SRConversationCell class] forCellReuseIdentifier:NSStringFromClass([SRConversationCell class])];
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreDataSource)];
        //        footer.automaticallyHidden = YES;
        // 设置文字
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        [footer setTitle:@"載入中，請稍後..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"" forState:MJRefreshStateNoMoreData];//沒有更多數據
        footer.triggerAutomaticallyRefreshPercent = 0.5;
        // 设置字体
        footer.stateLabel.font = [UIFont systemFontOfSize:14];
        // 设置颜色
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _tableView.mj_footer = footer;
    }
    return _tableView;
}

@end
