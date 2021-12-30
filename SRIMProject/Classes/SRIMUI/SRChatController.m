//
//  SRChatController.m
//  HKHouse591
//
//  Created by shuxiao on 2019/9/22.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRChatController.h"
#import "SRHouseContentCell.h"
#import "SRChatImageCell.h"
#import "SRChatPrivateCell.h"
#import "SRIMClient.h"
#import "SRChatContent.h"
#import "SRImageContent.h"
#import "SRHouseContent.h"
#import "SRChatPrivateCellViewModel.h"
#import "SRChatImageCellViewModel.h"
#import "SRHouseContentCellViewModel.h"
#import <MJRefresh/MJRefresh.h>
#import "SRChatToolView.h"
#import "SRIMImageExtension.h"
#import "SRIMSerializeExtension.h"
#import <PINCache/PINCache.h>
#import <MJExtension/MJExtension.h>
#import "SRIMUtility.h"
#import "SRIMNetworkManager.h"
#import "SRIMURLDefine.h"
#import "SRIMConsts.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "SREmojiKeyBoard.h"
#import "UIView+MJExtension.h"
#import "SRIMDatetimeExtension.h"
#import "SRChatTopCloseView.h"
#import "SRIMConfigure.h"
#import "SRIMToolExtension.h"

static NSString *kSRChatPrivateCellIdentifier = @"kSRChatPrivateCellIdentifier";
static NSString *kSRHouseContentCellIdentifier = @"kSRHouseContentCellIdentifier";
static NSString *kSRImageCellIdentifier = @"kSRImageCellIdentifier";

#define SRInputBarHeight 50
#define SREmojiKeyBoardHeight 200
#define SRChatToolViewHeight 100
#define SRChatTopViewHeight 58

typedef NS_ENUM(NSInteger, SRChatInputType) {
    SRChatInputTypeDefault = 0, //无任何输入
    SRChatInputTypeText,        //输入文本
    SRChatInputTypeEmoji,       //输入表情
    SRChatInputTypeCommonWords, //常用语
    SRChatInputTypePhoto        //照片or拍摄
};

@interface SRChatController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, TTTAttributedLabelDelegate, SRChatCellDelegate, SRChatToolViewDelegate, SREmojiKeyBoardDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, strong) UIView *inputBarView;
//
//@property (nonatomic, strong) UITextView *inputTextView;

@property (nonatomic, assign) CGFloat keyboardOriginY;

@property (nonatomic, assign) CGFloat inputBarHeight;

@property (nonatomic, strong) NSMutableArray *messageClasses;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, strong) SRChatToolView *toolView;
@property (nonatomic, strong) SREmojiKeyBoard *emojiView;
@property (nonatomic, strong) UIButton *extentButton;
@property (nonatomic, strong) UIButton *emojiButton;

@property (nonatomic, assign) SRChatInputType inputType;

@property (nonatomic, copy) NSDictionary *targetInfo;
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, copy) NSString *currentChatId;

@property (nonatomic, assign) NSInteger reloadTimes;

//只保存发送失败的消息数组,发送成功后再剔除
@property (nonatomic, strong) NSMutableArray *messagesArray;
//是否选中工具栏
@property (nonatomic, assign) BOOL selectingExtendToolAction;
//是否点击emoji表情
@property (nonatomic, assign) BOOL selectingEmojiAction;

@property (nonatomic, assign) CGFloat keyBoardHeight;

@property (nonatomic, assign) BOOL keyboardDidShowAlready;

//view的高度与viewHeight的差
@property (nonatomic, assign) CGFloat viewHeigthOff;
///初始的位置
@property (nonatomic, assign) CGRect inputBarFrame;
@property (nonatomic, assign) CGRect emojiKeyBoardFrame;
@property (nonatomic, assign) CGRect toolViewFrame;
@property (nonatomic, assign) CGRect inputTextFrame;
@property (nonatomic, assign) CGRect tableViewFrame;

@property (nonatomic, strong) SRChatTopCloseView *topCloseView;
@property (nonatomic, strong) SRIMConfigure *configure;

@end

@implementation SRChatController

#pragma mark - Life Cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = self.configure.chat_bg_color;
    if(self.target_name) self.navigationItem.title = self.target_name;
    self.reloadTimes = 3;
    self.inputBarHeight = SRInputBarHeight;
    [self setupView];
    [self fetchTargetUserInfoWithTargetId:self.target_uid];
    [self fetchHistoricalMsg:self.target_uid node_marker:@"" limit:@"10" token:[[SRIMClient shareClient] getToken]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHideAction:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageNotification:) name:SRIMDidReceiveChatMessageNotification object:nil];
    // Add a notification for keyboard change events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isSetHadRead && [SRIMToolExtension isPodVC:self]) {
        [self setHadReadMessage];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 自动回复

- (void)autoResponseWithText:(NSString *)text {
    SRChatModel *chatModel = [[SRChatModel alloc] init];
    SRChatContent *chatContent = [[SRChatContent alloc] init];
    chatContent.content = text;
    chatModel.content = chatContent;
    chatModel.arrivals_callback = 1;
    chatModel.from_uid = self.target_uid;
    chatModel.message_direction = 2;
    chatModel.target_uid = self.userInfo[@"user_id"];
    chatModel.status = 1;
    chatModel.type = SRIMMessageTypeTxt;
    SRChatPrivateCellViewModel *cellViewModel = [[SRChatPrivateCellViewModel alloc] initWithChatModel:chatModel];
    [cellViewModel updateUserInfo:self.targetInfo];
    [self.dataSource addObject:cellViewModel];
    [self.tableView reloadData];
    [self scrollToBottom:NO];
}

#pragma mark - 末尾添加Cell

- (void)appendMessage:(NSString *)content {
    [self cleanInputKeyBoard];
    SRChatModel *chatModel = [self generateChatModelWithContent:content type:SRIMMessageTypeTxt target_uid:self.target_uid];
    SRChatPrivateCellViewModel *cellViewModel = [[SRChatPrivateCellViewModel alloc] initWithChatModel:chatModel];
    [cellViewModel updateUserInfo:self.userInfo];
    [self.dataSource addObject:cellViewModel];
    [self.tableView reloadData];
    [self scrollToBottom:NO];
}

- (void)appendImageMessage:(NSString *)content {
    SRChatModel *chatModel = [self generateChatModelWithContent:content type:SRIMMessageTypeImg target_uid:self.target_uid];
    SRChatImageCellViewModel *cellViewModel = [[SRChatImageCellViewModel alloc] initWithChatModel:chatModel];
    [cellViewModel updateUserInfo:self.userInfo];
    [self.dataSource addObject:cellViewModel];
    [self.tableView reloadData];
    [self scrollToBottom:YES];
}

- (void)appendHouseMessage:(NSString *)content {
    SRChatModel *chatModel = [self generateChatModelWithContent:content type:SRIMMessageTypeCustom target_uid:self.target_uid];
    SRHouseContentCellViewModel *cellViewModel = [[SRHouseContentCellViewModel alloc] initWithChatModel:chatModel];
    [cellViewModel updateUserInfo:self.userInfo];
    [self.dataSource addObject:cellViewModel];
    [self.tableView reloadData];
    [self scrollToBottom:NO];
}

- (void)appendCustomizeMessage:(SRBaseContentModel *)content forMessageClass:(NSString *)messageClass {
    SRChatModel *chatModel = [self generateCustomizeMessageWithChatModel:content target_uid:self.target_uid messageClass:messageClass];
    SRIMBaseCellViewModel *cellViewModel = [[SRIMBaseCellViewModel alloc] init];
    cellViewModel.chatModel = chatModel;
    [cellViewModel updateUserInfo:self.userInfo];
    [self.dataSource addObject:cellViewModel];
    [self.tableView reloadData];
    [self scrollToBottom:NO];
}

#pragma mark - currentTimestamp

- (NSString *)currentTimestamp {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *currentTimeStamp = [formatter stringFromDate:date];
    return currentTimeStamp;
}

#pragma mark - setupView

- (void)setupView {
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.inputBarView];
    [self.inputBarView addSubview:self.inputTextView];
    [self.inputBarView addSubview:self.emojiButton];
    [self.inputBarView addSubview:self.extentButton];
    [self.extentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.inputTextView);
        make.right.mas_equalTo(self.inputBarView.mas_right).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    [self.emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.extentButton);
        make.right.mas_equalTo(self.extentButton.mas_left).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.emojiView];
    
    self.tableView.frame = self.tableViewFrame;
    
    if (self.showTopCloseView) {
        [self.view addSubview:self.topCloseView];
        self.topCloseView.titleLabel.text = self.target_name;
    }
    
}

#pragma mark - 发送消息

- (void)sendMsg:(NSString *)content
           type:(NSString *)type
     target_uid:(NSString *)target_uid
     shouldPush:(BOOL)push {
    if (!target_uid) {
        return;
    }
    //    [self finishAction];
    //push 物件消息和打招呼的传0 其余不传
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"token": [[SRIMClient shareClient] getToken],
                                                                                  @"type":type,
                                                                                  @"target_uid": target_uid,
                                                                                  @"content": content}];
    if (!push) {
        [params setObject:@(0) forKey:@"push"] ;
    }
    if ([self getSendMessageExtDic]) {
        [params addEntriesFromDictionary:[self getSendMessageExtDic]];
    }
    //    SRChatModel *chatModel = [self generateChatModelWithContent:content type:type target_uid:target_uid];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
    if (![self.messagesArray containsObject:indexPath]) {
        [self.messagesArray addObject:indexPath];
    }
    [[SRIMNetworkManager shareManager] loadDataWithUrl:[self getSendMessageUrl] method:@"POST" parameters:params success:^(id  _Nonnull responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        SRIMLog(@"sendMsg:%@", responseDic);
        if(SRIMIsDictionaryClass(responseDic))[self postMessageResult:responseDic];
        [self reloadMessageSendStatus:SRIMMessageSendStatusArrival ForIndexPath:indexPath];
        if ([type isEqualToString:SRIMMessageTypeCustom]) {
            [self sendCustomMessageFinished];
        }
        [self cleanChatListCache];
        [self cleanInputKeyBoard];
    } failureBlock:^(NSError * _Nonnull error) {
        [self postMessageResult:@{@"code": @(error.code)}];
        if ([type isEqualToString:SRIMMessageTypeCustom]) {
            [self sendCustomMessageFinished];
        }
        [self cleanInputKeyBoard];
        [self reloadMessageSendStatus:SRIMMessageSendStatusFailure ForIndexPath:indexPath];
    }];
    
}

/// 获取发送消息的URL
- (NSString *)getSendMessageUrl{
    return SRIMSendMsg;
}

/// 发送消息扩展字段
- (NSDictionary *)getSendMessageExtDic{
    return nil;
}

/// 发送消息回调
- (void)postMessageResult:(NSDictionary *)json{
    
}
#pragma mark - 自定义物件消息发送完成

- (void)sendCustomMessageFinished {
    
}

// 清空文本
- (void)cleanInputKeyBoard {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.inputTextView.text.length || self.inputTextView.isFirstResponder) {
            self.inputTextView.text = @"";
            self.inputBarHeight = SRInputBarHeight;
            self.inputTextView.frame = self.inputTextFrame;
            if (self.selectingExtendToolAction) {
                [self extendToolAction];
            }else if(self.selectingEmojiAction){
                [self emojiToolAction];
            }else{
                self.inputBarView.frame = CGRectMake(0, self.keyboardOriginY - self.inputBarHeight  - self.viewHeigthOff, SRIMScreenWidth, self.inputBarHeight);
                self.tableView.frame = self.tableViewFrame;
                [self scrollToBottom:NO];
            }
//            [self inputBarViewOriginYChanged:self.keyboardOriginY - self.inputBarHeight  - self.viewHeigthOff];
        }
    });
}

- (void)reloadMessageSendStatus:(SRIMMessageSendStatus )status ForIndexPath:(NSIndexPath *)indexPath {
    if (status == SRIMMessageSendStatusArrival && [self.messagesArray containsObject:indexPath]) {
        [self.messagesArray removeObject:indexPath];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[SRChatPrivateCellViewModel class]]) {
            SRChatPrivateCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
            cellViewModel.chatModel.sendStatus = status;
            [self.dataSource replaceObjectAtIndex:indexPath.row withObject:cellViewModel];
        }
        else if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[SRChatImageCellViewModel class]]) {
            SRChatImageCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
            cellViewModel.chatModel.sendStatus = status;
            [self.dataSource replaceObjectAtIndex:indexPath.row withObject:cellViewModel];
        }
        else if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[SRHouseContentCellViewModel class]]) {
            SRHouseContentCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
            cellViewModel.chatModel.sendStatus = status;
            [self.dataSource replaceObjectAtIndex:indexPath.row withObject:cellViewModel];
        }
        else {
            SRIMBaseCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
            for (NSString *messageClass in self.messageClasses) {
                if ([messageClass isEqualToString:NSStringFromClass([cellViewModel.chatModel.content class])]) {
                    cellViewModel.chatModel.sendStatus = status;
                    [self.dataSource replaceObjectAtIndex:indexPath.row withObject:cellViewModel];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
    });
}

#pragma mark - 通过消息内容生成待发送的ChatModel

- (SRChatModel *)generateChatModelWithContent:(NSString *)content type:(NSString *)type target_uid:(NSString *)target_uid {
    SRChatModel *chatModel = [[SRChatModel alloc] init];
    NSDictionary *dic = [SRIMSerializeExtension dictionaryWithJsonString:content];
    chatModel.arrivals_callback = 1;
    chatModel.message_direction = 1;
    chatModel.from_uid = self.userInfo[@"user_id"];
    chatModel.target_uid = target_uid;
    chatModel.send_time = [SRIMDatetimeExtension currentTimestamp];
    chatModel.status = 1;
    chatModel.target_uid = self.target_uid;
    chatModel.type = type;
    chatModel.sendStatus = SRIMMessageSendStatusSending;
    if (!dic) {
        return chatModel;
    }
    else {
        if ([type isEqualToString:SRIMMessageTypeTxt]) {
            SRChatContent *chatContent = [SRChatContent mj_objectWithKeyValues:dic];
            chatModel.content = chatContent;
        }
        else if ([type isEqualToString:SRIMMessageTypeImg]) {
            SRImageContent *imageContent = [SRImageContent mj_objectWithKeyValues:dic];
            chatModel.content = imageContent;
        }
        else if ([type isEqualToString:SRIMMessageTypeCustom]) {
            SRHouseContent *houseContent = [SRHouseContent mj_objectWithKeyValues:dic];
            chatModel.content = houseContent;
        }
        return chatModel;
    }
}

- (SRChatModel *)generateCustomizeMessageWithChatModel:(SRBaseContentModel *)contentModel target_uid:(NSString *)target_uid messageClass:(NSString *)messageClass {
    SRChatModel *chatModel = [[SRChatModel alloc] init];
    chatModel.arrivals_callback = 1;
    chatModel.message_direction = 1;
    chatModel.from_uid = self.userInfo[@"user_id"];
    chatModel.target_uid = target_uid;
    chatModel.send_time = [self currentTimestamp];
    chatModel.status = 1;
    chatModel.type = SRIMMessageTypeCustom;
    chatModel.sendStatus = SRIMMessageSendStatusSending;
    chatModel.content = contentModel;
    return chatModel;
}

#pragma mark - 获取聊天双方用户信息

- (void)fetchTargetUserInfoWithTargetId:(NSString *)target_uid {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[[SRIMClient shareClient] getToken] forKey:@"token"];
    [params setObject:target_uid forKey:@"target_uid"];
    NSString *url = SRIMGetConversationInfo;
    [[SRIMNetworkManager shareManager] loadDataWithUrl:url method:@"GET" parameters:params success:^(id  _Nonnull responseObject) {
        NSDictionary *data = responseObject[@"data"];
        NSObject *targetObj = data[@"target"];
        if ([targetObj isKindOfClass:[NSArray class]]) {
            NSArray *targetArr = (NSArray *)targetObj;
            if (targetArr.count) {
                self.targetInfo = targetArr.firstObject;
            }
        }
        else if ([targetObj isKindOfClass:[NSDictionary class]]) {
            NSDictionary *targetDic = data[@"target"];
            self.targetInfo = targetDic;
        }
        NSDictionary *userDic = data[@"user"];
        self.userInfo = userDic;
        if (self.targetInfo) {
            self.navigationItem.title = self.targetInfo[@"nickname"];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        //
    }];
}

#pragma mark - 获取历史聊天记录

- (void)fetchHistoricalMsg:(NSString *)link_user node_marker:(NSString *_Nullable )node_marker limit:(NSString *_Nullable )limit token:(NSString *)token {
    NSMutableDictionary *mutableParams = [[NSMutableDictionary alloc] initWithCapacity:0];
    [mutableParams setObject:link_user forKey:@"link_user"];
    if (node_marker && node_marker.length) {
        [mutableParams setObject:node_marker forKey:@"node_marker"];
    }
    if (limit && limit.length) {
        [mutableParams setObject:limit forKey:@"limit"];
    }
    [mutableParams setObject:token forKey:@"token"];
    
    [[SRIMNetworkManager shareManager] loadDataWithUrl:SRIMHistoricalMessage method:@"GET" parameters:mutableParams success:^(id  _Nonnull responseObject) {
        [self.tableView.mj_header endRefreshing];
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        SRIMLog(@"HistoricalMsg:%@", responseDic);
        NSDictionary *historyDic = responseDic[@"data"];
        NSArray *historyArr = historyDic[@"data"];
        //        if (self.isSetHadRead) {
        //            [self readMessageWithTargetUid:self.target_uid];
        //        }
        if (historyArr.count) {
            NSDictionary *lastDic = historyArr.lastObject;
            NSString *chatId = [NSString stringWithFormat:@"%@", lastDic[@"id"]];
            if ([self.currentChatId isEqualToString:chatId]) {
                //
                [self finishLoadData:YES];
            }
            else {
                self.currentChatId = chatId;
                for (NSDictionary *chatContentModel in historyArr) {
                    SRChatModel *chatModel = [SRChatModel mj_objectWithKeyValues:chatContentModel];
                    NSString *type = chatContentModel[@"type"];
                    if ([type isEqualToString:SRIMMessageTypeTxt]) {
                        if (chatContentModel[@"content"] && ![chatContentModel[@"content"] isEqual:[NSNull null]]) {
                            SRChatContent *chatContent = [SRChatContent mj_objectWithKeyValues:chatContentModel[@"content"]];
                            chatModel.content = chatContent;
                            SRChatPrivateCellViewModel *cellViewModel = [[SRChatPrivateCellViewModel alloc] initWithChatModel:chatModel];
                            if (chatModel.message_direction == 1) {
                                [cellViewModel updateUserInfo:self.userInfo];
                            }
                            else if (chatModel.message_direction == 2) {
                                [cellViewModel updateUserInfo:self.targetInfo];
                            }
                            [self.dataSource insertObject:cellViewModel atIndex:0];
                        }
                    }
                    else if ([type isEqualToString:SRIMMessageTypeCustom]) {
                        if (chatContentModel[@"content"] && ![chatContentModel[@"content"] isEqual:[NSNull null]] && ![chatContentModel[@"content"] isKindOfClass:[NSArray class]]) {
                            SRIMBaseCellViewModel *cellViewModel = [[SRIMBaseCellViewModel alloc] init];
                            chatModel.content = [self propertiesWithKeyValues:chatContentModel[@"content"]];
                            cellViewModel.chatModel = chatModel;
                            if (chatModel.message_direction == 1) {
                                [cellViewModel updateUserInfo:self.userInfo];
                            }
                            else if (chatModel.message_direction == 2) {
                                [cellViewModel updateUserInfo:self.targetInfo];
                            }
                            [self.dataSource insertObject:cellViewModel atIndex:0];
                        }
                    }
                    else if ([type isEqualToString:SRIMMessageTypeImg]) {
                        if (chatContentModel[@"content"] && ![chatContentModel[@"content"] isEqual:[NSNull null]]) {
                            SRImageContent *imageContent = [SRImageContent mj_objectWithKeyValues:chatContentModel[@"content"]];
                            chatModel.content = imageContent;
                            SRChatImageCellViewModel *cellViewModel = [[SRChatImageCellViewModel alloc] initWithChatModel:chatModel];
                            if (chatModel.message_direction == 1) {
                                [cellViewModel updateUserInfo:self.userInfo];
                            }
                            else if (chatModel.message_direction == 2) {
                                [cellViewModel updateUserInfo:self.targetInfo];
                            }
                            [self.dataSource insertObject:cellViewModel atIndex:0];
                        }
                    }
                }
                [self finishLoadData:NO];
            }
            if ((!node_marker || node_marker.length == 0) && self.dataSource.count > 1) {
                [self scrollToBottom:YES];
            }
        }
        else {
            self.reloadTimes -= 1;
            if (self.reloadTimes > 0) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self fetchHistoricalMsg:link_user node_marker:node_marker limit:limit token:token];
                });
            }
            else {
                self.reloadTimes = 3;
            }
            [self finishLoadData:YES];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        [self failureLoadData:error];
        [self.tableView.mj_header endRefreshing];
    }];
}

//错误的加载
- (void)failureLoadData:(NSError *)error{
    [self.tableView reloadData];
}

//请求完成加载
- (void)finishLoadData:(BOOL)isEmpty{
    [self.tableView reloadData];
}

#pragma mark - 设置消息已读
- (void)setHadReadMessage{
    __weak typeof(self) weakSelf = self;
    NSDictionary *params = @{@"token": [[SRIMClient shareClient] getToken], @"target_uid": SRIMNullClass(self.target_uid)};
    [[SRIMNetworkManager shareManager] loadDataWithUrl:SRIMReadTargetUserMessage method:@"POST" parameters:params success:^(id  _Nonnull responseObject) {
        [weakSelf cleanChatListCache];
        [[NSNotificationCenter defaultCenter] postNotificationName:SRIMDidUpdateReadMessageNotification object:nil userInfo:nil];
    } failureBlock:^(NSError * _Nonnull error) {
        //
    }];
}

#pragma mark - cleanChatListCache
- (void)cleanChatListCache {
    NSString *key = [SRIMConversationList stringByAppendingFormat:@"&token=%@", [[SRIMClient shareClient] getToken]];
    if ([[PINCache sharedCache] containsObjectForKey:key]) {
        [[PINCache sharedCache] removeObjectForKey:key];
    }
}

#pragma mark - Action

- (void)historyMessageAction {
    NSString *linknode = self.currentChatId;
    [self fetchHistoricalMsg:self.target_uid node_marker:linknode limit:@"10" token:[[SRIMClient shareClient] getToken]];
}

// 发送完成
- (void)finishAction {
    if (!self.inputTextView.isFirstResponder) {
        return;
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.toolView.frame = self.toolViewFrame;
        self.inputBarView.frame = CGRectMake(0, self.keyboardOriginY - self.inputBarHeight, SRIMScreenWidth, self.inputBarHeight);
        self.emojiView.frame = self.emojiKeyBoardFrame;
    }];
}

#pragma mark - 上传图片

- (void)uploadImage:(UIImage *)image {
    [self willSendingMsg:@{@"type":SRIMMessageTypeImg}];
    [self upLoadImgStatus:SRIMMessageSendStatusPrepare];
    NSData *compressData = [SRIMImageExtension smartCompressImage:image];
    [[SRIMNetworkManager shareManager] uploadImageWithUrl:SRIMUploadPicture data:compressData token:[[SRIMClient shareClient] getToken] filaName:@"123456" success:^(id  _Nonnull responseObject) {
        SRIMLog(@"upload Image result:%@", responseObject);
        if ([responseObject[@"code"] intValue] == 200) {
            NSDictionary *imageDic = [responseObject objectForKey:@"data"];
            NSString *img_url = [imageDic objectForKey:@"img_url"];
            NSString *thumbnail_url = [imageDic objectForKey:@"thumbnail_url"];
            NSDictionary *messageDic = @{@"img_url": img_url, @"thumbnail_url": thumbnail_url};
            NSString *messageContent = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:messageDic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            [self appendImageMessage:messageContent];
            [self upLoadImgStatus:SRIMMessageSendStatusArrival];
            [self sendMsg:messageContent type:SRIMMessageTypeImg target_uid:self.target_uid shouldPush:YES];
        }
        else {
            [self upLoadImgStatus:SRIMMessageSendStatusFailure];
        }
    } failure:^(NSError * _Nonnull error) {
        SRIMLog(@"upload Image Error:%@", error);
        [self upLoadImgStatus:SRIMMessageSendStatusFailure];
    }];
}

- (void)uploadMultipleImages:(NSArray <UIImage *> *)images completionBlock:(void (^)(void))completionBlock {
    dispatch_group_t group = dispatch_group_create();
    for (UIImage *image in images) {
        [self willSendingMsg:@{@"type":SRIMMessageTypeImg}];
        [self upLoadImgStatus:SRIMMessageSendStatusPrepare];
        dispatch_group_enter(group);
        NSData *compressData = [SRIMImageExtension smartCompressImage:image];
        NSString *imageName = [self createImageUUID:@"img"];
        [[SRIMNetworkManager shareManager] uploadImageWithUrl:SRIMUploadPicture data:compressData token:[[SRIMClient shareClient] getToken] filaName:imageName success:^(id  _Nonnull responseObject) {
            SRIMLog(@"upload Image result:%@", responseObject);
            if ([responseObject[@"code"] intValue] == 200) {
                NSDictionary *imageDic = [responseObject objectForKey:@"data"];
                NSString *img_url = [imageDic objectForKey:@"img_url"];
                NSString *thumbnail_url = [imageDic objectForKey:@"thumbnail_url"];
                NSDictionary *messageDic = @{@"img_url": img_url, @"thumbnail_url": thumbnail_url};
                NSString *messageContent = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:messageDic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self appendImageMessage:messageContent];
                    [self upLoadImgStatus:SRIMMessageSendStatusArrival];
                    [self sendMsg:messageContent type:SRIMMessageTypeImg target_uid:self.target_uid shouldPush:YES];
                });
            }
            else {
                [self upLoadImgStatus:SRIMMessageSendStatusFailure];
            }
            dispatch_group_leave(group);
        } failure:^(NSError * _Nonnull error) {
            SRIMLog(@"upload Image Error:%@", error);
            [self upLoadImgStatus:SRIMMessageSendStatusFailure];
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        SRIMLog(@"图片全部发送完成");
        completionBlock();
    });
}

- (NSString *)createImageUUID:(NSString *)prefix {
   NSString *  result;
   CFUUIDRef  uuid;
   CFStringRef uuidStr;
   uuid = CFUUIDCreate(NULL);
   uuidStr = CFUUIDCreateString(NULL, uuid);
   result =[NSString stringWithFormat:@"%@-%@", prefix,uuidStr];
   CFRelease(uuidStr);
   CFRelease(uuid);
   return result;
}

#pragma mark - 发送文本消息Action

- (void)sendMsgAction {
    if (self.inputTextView.text.length == 0) {
        return;
    }
    NSString *content = self.inputTextView.text;
    NSString *target_uid = self.target_uid;
    NSString *type = SRIMMessageTypeTxt;
    NSDictionary *contentDic = @{@"content":content, @"extra" : [NSNull null]};
    NSString *contentStr = [SRIMSerializeExtension jsonStringWithDic:contentDic];
    [self willSendingMsg:@{@"type":SRIMMessageTypeTxt,@"content":content}];
    [self appendMessage:contentStr];
    [self sendMsg:contentStr type:type target_uid:target_uid shouldPush:YES];
}

#pragma mark - 滚动最低部
- (void)scrollToBottom:(BOOL)isAfter{
    if (isAfter) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollToLastIndexRow];
        });
    }else{
        [self scrollToLastIndexRow];
    }
}

- (void)scrollToViewBottom{
    if (self.tableView.contentSize.height <= self.tableView.frame.size.height) {
        return;
    }
    CGPoint bottomOffset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.bounds.size.height);
    [self.tableView setContentOffset:bottomOffset animated:NO];
}

- (void)scrollToLastIndexRow{
    if (self.dataSource.count) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark - Override Method
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    self.inputTextView.layer.borderColor = (self.configure.chat_inputBar_inputTextView_broder_color ? self.configure.chat_inputBar_inputTextView_broder_color : SRIMColorFromRGB(0xcccccc)).CGColor;
}


#pragma mark - NSNotification

- (void)receiveMessageNotification:(NSNotification *)notify {
    NSDictionary *userInfo = notify.userInfo;
    NSString *from_uid = userInfo[@"from_uid"];
    NSString *type = userInfo[@"type"];
    [self cleanChatListCache];
    if ([from_uid isEqualToString:self.target_uid]) {
        SRChatModel *chatModel = [SRChatModel mj_objectWithKeyValues:userInfo];
        if ([type isEqualToString:SRIMMessageTypeTxt]) {
            SRChatContent *chatContent = [SRChatContent mj_objectWithKeyValues:userInfo[@"content"]];
            chatModel.content = chatContent;
            SRChatPrivateCellViewModel *cellViewModel = [[SRChatPrivateCellViewModel alloc] initWithChatModel:chatModel];
            if (chatModel.message_direction == 1) {
                [cellViewModel updateUserInfo:self.userInfo];
            }
            else if (chatModel.message_direction == 2) {
                [cellViewModel updateUserInfo:self.targetInfo];
            }
            [self.dataSource addObject:cellViewModel];
            [self.tableView reloadData];
            [self scrollToBottom:YES];
        }
        else if ([type isEqualToString:SRIMMessageTypeCustom]) {
            SRIMBaseCellViewModel *cellViewModel = [[SRIMBaseCellViewModel alloc] init];
            chatModel.content = [self propertiesWithKeyValues:userInfo[@"content"]];
            cellViewModel.chatModel = chatModel;
            if (chatModel.message_direction == 1) {
                [cellViewModel updateUserInfo:self.userInfo];
            }
            else if (chatModel.message_direction == 2) {
                [cellViewModel updateUserInfo:self.targetInfo];
            }
            [self.dataSource addObject:cellViewModel];
            [self.tableView reloadData];
            [self scrollToBottom:YES];
        }
        else if ([type isEqualToString:SRIMMessageTypeImg]) {
            SRImageContent *imageContent = [SRImageContent mj_objectWithKeyValues:userInfo[@"content"]];
            chatModel.content = imageContent;
            SRChatImageCellViewModel *imageCellViewModel = [[SRChatImageCellViewModel alloc] initWithChatModel:chatModel];
            if (chatModel.message_direction == 1) {
                [imageCellViewModel updateUserInfo:self.userInfo];
            }
            else if (chatModel.message_direction == 2) {
                [imageCellViewModel updateUserInfo:self.targetInfo];
            }
            [self.dataSource addObject:imageCellViewModel];
            [self.tableView reloadData];
            [self scrollToBottom:YES];
        }
    }
}

- (void)keyBoardWillShowAction:(NSNotification *)notify {
    CGRect keyboardBeginFrame = [notify.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardEndFrame = [notify.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval timeInterval = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //    [self finishAction];
    self.keyboardOriginY = keyboardEndFrame.origin.y;
    if (keyboardBeginFrame.size.height > 0 && keyboardBeginFrame.origin.y - keyboardEndFrame.origin.y > 0) {
        [UIView animateWithDuration:timeInterval animations:^{
            self.inputBarHeight = SRInputBarHeight;
            self.inputTextView.frame = self.inputTextFrame;
            self.inputBarView.frame = CGRectMake(0, self.keyboardOriginY - self.inputBarHeight  - self.viewHeigthOff, SRIMScreenWidth, self.inputBarHeight);
            self.tableView.frame = self.tableViewFrame;
            [self scrollToBottom:NO];
            [self inputBarViewOriginYChanged:self.keyboardOriginY - self.inputBarHeight  - self.viewHeigthOff];
        }];
    }
    self.keyboardDidShowAlready = YES;
    self.selectingEmojiAction = NO;
    self.selectingExtendToolAction = NO;
}

- (void)keyBoardWillHideAction:(NSNotification *)notify {
    CGRect keyboardBeginFrame = [notify.userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect keyboardEndFrame = [notify.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    NSTimeInterval timeInterval = [notify.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];//动画持续时间
    SRIMLog(@"timeInterval:%.4f", timeInterval);
    self.keyboardOriginY = 0;
    SRIMLog(@"keyboardBeginFrame : %@ keyboardEndFrame:%@", NSStringFromCGRect(keyboardBeginFrame), NSStringFromCGRect(keyboardEndFrame));
    
    if (timeInterval) {
        [UIView animateWithDuration:timeInterval animations:^{
            self.inputBarView.frame = self.inputBarFrame;
            self.toolView.frame = self.toolViewFrame;
            self.emojiView.frame = self.emojiKeyBoardFrame;
            self.tableView.frame = self.tableViewFrame;
            [self scrollToBottom:NO];
            [self inputBarViewOriginYChanged:self.viewHeight - SRInputBarHeight - [self safeAreaHeight]];
        }];
    }
    self.keyboardDidShowAlready = NO;
}

//https://github.com/bmancini55/iOSExamples-BottomScrollPosition
-(void)keyboardWillChange:(NSNotification *)notification
{
    CGRect beginFrame = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame =  [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (fabs(beginFrame.origin.y - UIScreen.mainScreen.bounds.size.height) < 0.1 ||
        fabs(endFrame.origin.y - UIScreen.mainScreen.bounds.size.height) < 0.1) {
        return;
    }
    CGFloat delta = (endFrame.origin.y - beginFrame.origin.y);//deal就是键盘高度的增量变化
    SRIMLog(@"Keyboard YDelta %f -> B: %@, E: %@", delta, NSStringFromCGRect(beginFrame), NSStringFromCGRect(endFrame));
    self.keyboardOriginY = endFrame.origin.y;
    if(fabs(delta) > 0.0) {
        NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
        UIViewAnimationOptions options = (curve << 16) | UIViewAnimationOptionBeginFromCurrentState;
        
        [UIView animateWithDuration:duration delay:0 options:options animations:^{
            self.inputBarView.frame = CGRectOffset(self.inputBarView.frame, 0, delta);
            self.tableView.frame = CGRectOffset(self.tableView.frame, 0, delta);
        } completion:nil];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 500) {
        self.inputTextView.text = [textView.text substringToIndex:499];
    }
    else {
        NSString *text = textView.text;
        CGRect bounds = [text boundingRectWithSize:CGSizeMake(SRIMScreenWidth - 100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil];
        CGFloat textHeight = bounds.size.height + 22;
        if (textHeight < 40) {
            textHeight = 40;
        } else if (textHeight >= 90){
            textHeight = 90;
        }
        self.inputBarHeight = textHeight + 10;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.inputTextView.frame = CGRectMake(10, 5, SRIMScreenWidth - SRChatToolViewHeight, textHeight);
            self.inputBarView.frame = CGRectMake(0, self.keyboardOriginY - self.inputBarHeight  - self.viewHeigthOff, SRIMScreenWidth, self.inputBarHeight);
            self.tableView.frame = self.tableViewFrame;
            [self scrollToBottom:NO];
            [self inputBarViewOriginYChanged:self.keyboardOriginY - self.inputBarHeight  - self.viewHeigthOff];
        });
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![textView hasText] && [text isEqualToString:@""]) {
        return NO;
    }
    
    if (textView.text.length >= 500 && ![text isEqualToString:@""]) {
        return NO;
    }
    
    if ([text isEqualToString:@"\n"]) {
        [self sendMsgAction];
        NSString *trimString = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (trimString.length > 0) {
            for (int i = 0; i < textView.text.length; i ++) {
                if ([textView.text characterAtIndex:i] == 0xfffc) {
                    return NO;
                }
            }
            textView.text = @"";
        }
        else {
            return NO;
        }
    }
    if ([text isEqualToString:@""]) {
        
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[SRChatPrivateCellViewModel class]]) {
        SRChatPrivateCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
        CGFloat height = [tableView fd_heightForCellWithIdentifier:kSRChatPrivateCellIdentifier cacheByIndexPath:indexPath configuration:^(SRChatPrivateCell *cell) {
            cell.cellViewModel = cellViewModel;
        }];
        return height;
    }
    else if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[SRHouseContentCellViewModel class]]){
        SRHouseContentCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
        CGFloat height = [tableView fd_heightForCellWithIdentifier:kSRHouseContentCellIdentifier cacheByIndexPath:indexPath configuration:^(SRHouseContentCell *cell) {
            cell.cellViewModel = cellViewModel;
        }];
        return height;
    }
    else if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[SRChatImageCellViewModel class]]) {
        SRChatImageCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
        CGFloat height = [tableView fd_heightForCellWithIdentifier:kSRImageCellIdentifier configuration:^(SRChatImageCell *cell) {
            cell.cellViewModel = cellViewModel;
        }];
        return height;
    }
    else {
        return [self srIMChatTableView:tableView sizeForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self heightForTableViewHeaderInSection: section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //    [self willDisplayMessageCell:cell atIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[SRChatPrivateCellViewModel class]]) {
        SRChatPrivateCell *cell = [tableView dequeueReusableCellWithIdentifier:kSRChatPrivateCellIdentifier];
        cell.attributeTextLabel.delegate = self;
        cell.attributeTextLabel.enabledTextCheckingTypes = NSTextCheckingTypePhoneNumber | NSTextCheckingTypeLink;
        SRChatPrivateCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
        cell.cellViewModel = cellViewModel;
        cell.delegate = self;
        
        [self configureCell:cell text:cellViewModel.contentString];
        return cell;
    }
    else if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[SRHouseContentCellViewModel class]]){
        SRHouseContentCell *cell = [tableView dequeueReusableCellWithIdentifier:kSRHouseContentCellIdentifier];
        SRHouseContentCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
        cell.cellViewModel = cellViewModel;
        __weak typeof(self) weakSelf = self;
        cell.block = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf tapForCellViewModel:cellViewModel];
        };
        return cell;
    }
    else if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[SRChatImageCellViewModel class]]) {
        SRChatImageCell *cell = [tableView dequeueReusableCellWithIdentifier:kSRImageCellIdentifier];
        SRChatImageCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
        cell.cellViewModel = cellViewModel;
        __weak typeof(self) weakSelf = self;
        cell.imageBlock = ^(SRChatImageCellViewModel * _Nonnull cellViewModel) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSString *currentImgStr = [self getImageContentImgUrl:cellViewModel];
            [strongSelf presentImagePreviewCurrent:currentImgStr];
            //            NSMutableArray *imageURLArr = [NSMutableArray array];
            //            for (SRChatImageCellViewModel *model in [strongSelf.dataSource copy]) {
            //                if ([model isKindOfClass:[SRChatImageCellViewModel class]]) {
            //                    NSString *imgUrl = [self getImageContentImgUrl:model];
            //                    if ([imgUrl length] == 0) {
            //                        continue;
            //                    }
            //                    [imageURLArr addObject:imgUrl];
            //                }
            //            }
            //            NSUInteger index = [imageURLArr indexOfObject:currentImgStr];
            //            if (imageURLArr.count > index) {
            //                [strongSelf presentImagePreviewController:imageURLArr forRowAtIndex:index];
            //            }
        };
        return cell;
    }
    else {
        SRIMBaseCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
        if ([[cellViewModel.chatModel.content class] isSubclassOfClass:[SRBaseContentModel class]]) {
            return [self srIMChatTableView:tableView cellForRowAtIndexPath:indexPath];
        }
        else {
            return [[UITableViewCell alloc] init];
        }
    }
}

/// 用于文本消息Cell中的消息内容富文本label添加交互事件(如超链接点击等)
/// @param label TTTAttributedLabel
/// @param contentStr 消息文本内容
- (void)configureCell:(SRChatContentBaseCell *)cell text:(NSString *)contentStr {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self viewForTableViewHeaderInSection:section];
}

#pragma mark -- 获取图片url
- (NSString *)getImageContentImgUrl:(SRChatImageCellViewModel *)cellViewModel{
    SRImageContent *imageContent = (SRImageContent *)cellViewModel.chatModel.content;
    return SRIMNullClass(imageContent.img_url);
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[SRChatPrivateCellViewModel class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    if (action == @selector(copy:)) {
        if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[SRChatPrivateCellViewModel class]]) {
            SRChatPrivateCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
            [UIPasteboard generalPasteboard].string = [cellViewModel contentString];
        }
    }
}

#pragma mark -- 物件Cell跳转

- (void)tapForCellViewModel:(SRHouseContentCellViewModel *)cellViewModel {
    [self didTapCustomizeCell:cellViewModel.chatModel.content];
}

#pragma mark - SRChatCellDelegate

- (void)errorBtnEventForIndexPath:(NSIndexPath *)indexPath {
    SRChatModel *chatModel = nil;
    NSString *jsonStr = nil;
    NSString *type = nil;
    NSString *targetUid = nil;
    
    if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[SRChatPrivateCellViewModel class]]) {
        SRChatPrivateCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
        chatModel = cellViewModel.chatModel;
        chatModel.sendStatus = SRIMMessageSendStatusSending;
        cellViewModel.chatModel = chatModel;
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:cellViewModel];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        SRChatContent *chatContent = (SRChatContent *)chatModel.content;
        if (!chatContent) {
            return;
        }
        NSDictionary *dic = chatContent.mj_keyValues;
        jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        type = chatModel.type;
        targetUid = chatModel.target_uid;
    }
    else if ([[self.dataSource objectAtIndex:indexPath.row] isKindOfClass:[SRChatPrivateCellViewModel class]]) {
        SRChatImageCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
        chatModel = cellViewModel.chatModel;
        chatModel.sendStatus = SRIMMessageSendStatusSending;
        cellViewModel.chatModel = chatModel;
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:cellViewModel];
        SRImageContent *imageContent = (SRImageContent *)chatModel.content;
        if (!imageContent) {
            return;
        }
        NSDictionary *dic = imageContent.mj_keyValues;
        jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        type = chatModel.type;
        targetUid = chatModel.target_uid;
    }
    else {
        SRHouseContentCellViewModel *cellViewModel = [self.dataSource objectAtIndex:indexPath.row];
        chatModel = cellViewModel.chatModel;
        chatModel.sendStatus = SRIMMessageSendStatusSending;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        cellViewModel.chatModel = chatModel;
        [self.dataSource replaceObjectAtIndex:indexPath.row withObject:cellViewModel];
        SRHouseContent *houseContent = (SRHouseContent *)chatModel.content;
        if (!houseContent) {
            return;
        }
        NSDictionary *dic = houseContent.mj_keyValues;
        jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        type = chatModel.type;
        targetUid = chatModel.target_uid;
    }
    if (targetUid == nil || jsonStr == nil || type == nil) {
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{@"token": [[SRIMClient shareClient] getToken],
                                                                                  @"type":type,
                                                                                  @"target_uid": targetUid,
                                                                                  @"content": jsonStr}];
    if ([self getSendMessageExtDic]) {
        [params addEntriesFromDictionary:[self getSendMessageExtDic]];
    }
    [self willSendingMsg:@{@"type":type}];
    [[SRIMNetworkManager shareManager] loadDataWithUrl:[self getSendMessageUrl] method:@"POST" parameters:params success:^(id  _Nonnull responseObject) {
        NSDictionary *responseDic = (NSDictionary *)responseObject;
        SRIMLog(@"sendMsg:%@", responseDic);
        if(SRIMIsDictionaryClass(responseDic))[self postMessageResult:responseDic];
        [self reloadMessageSendStatus:SRIMMessageSendStatusArrival ForIndexPath:indexPath];
        [self cleanChatListCache];
    } failureBlock:^(NSError * _Nonnull error) {
        [self reloadMessageSendStatus:SRIMMessageSendStatusFailure ForIndexPath:indexPath];
    }];
}

#pragma mark -TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    NSString *urlString = url.absoluteString;
    [self didTapUrlInChatCell:urlString];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    [self didTapPhoneNumberInChatCell:phoneNumber];
}

#pragma mark - SRChatToolViewDelegate

- (void)didSelectImagePickerType:(NSInteger)pickerType {
    if (pickerType == 0) {
        //照片
        [self photoImagePicker];
    }
    else if (pickerType == 1) {
        //拍摄
        UIImagePickerController *pickerCtl = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            pickerCtl.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        pickerCtl.delegate = self;
        [self presentViewController:pickerCtl animated:YES completion:NULL];
    }
}

/// 如果继承者有自定义的相册选择器，则需要重写此方法并实现具体的Present和Dismiss
- (void )photoImagePicker {
    UIImagePickerController *pickerCtl = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        pickerCtl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    pickerCtl.delegate = self;
    [self presentViewController:pickerCtl animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self uploadImage:image];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - SREmojiKeyBoardDelegate

- (void)appendEmoji:(NSString *)emoji {
    self.inputTextView.text = [self.inputTextView.text stringByAppendingString:emoji];
    //    [self textViewDidChange:self.inputTextView];  //待处理emoje 输入 主要是键盘的值为keyboardOriginY = 0
    SRIMLog(@"self.inputTextView.text:%@ length:%zi", self.inputTextView.text, self.inputTextView.text.length);
    
}

- (void)deleteEmojiCharacter {
    if (!self.inputTextView.text.length) {
        return;
    }
    id<UITextInputTokenizer> tokenizer = [self.inputTextView tokenizer];
    UITextPosition *pos = self.inputTextView.endOfDocument;
    UITextPosition *textPosition = [self.inputTextView positionFromPosition:pos offset:0];
    
    UITextRange *range = [tokenizer rangeEnclosingPosition:textPosition withGranularity:UITextGranularityCharacter inDirection:UITextStorageDirectionBackward];
    NSString *oneCharacter = [self.inputTextView textInRange:range];
    SRIMLog(@"oneCharacter:%@", oneCharacter);
    NSInteger offset  = [self.inputTextView offsetFromPosition:range.start toPosition:range.end];
    SRIMLog(@"offset=%zi", offset);
    if (offset) {
        self.inputTextView.text = [self.inputTextView.text substringToIndex:self.inputTextView.text.length - offset];
    }
    SRIMLog(@"self.inputTextView.text:%@ length:%zi", self.inputTextView.text, self.inputTextView.text.length);
}

- (void)sendMessage {
    if (!self.inputTextView.text.length) {
        return;
    }
    [self sendMsgAction];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (translation.y>0) {//下滑收起所有
        [self hideKeyboardAndInputView];
    }
}

#pragma mark - ToolInput(照片 or 拍摄)

- (void)extendToolAction {
    if (self.selectingExtendToolAction) {
        return;
    }
    [self.inputTextView resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.inputBarView.frame = CGRectMake(0, self.viewHeight - SRChatToolViewHeight - [self safeAreaHeight] - self.inputBarHeight, SRIMScreenWidth, self.inputBarHeight);
        self.toolView.frame = CGRectMake(0, self.viewHeight - SRChatToolViewHeight - [self safeAreaHeight], SRIMScreenWidth, SRChatToolViewHeight + [self safeAreaHeight]);
        self.emojiView.frame = self.emojiKeyBoardFrame;
        self.tableView.frame = self.tableViewFrame;
        [self scrollToBottom:NO];
        [self inputBarViewOriginYChanged:self.viewHeight - SRChatToolViewHeight - [self safeAreaHeight] - self.inputBarHeight];
    }];
    
    self.selectingExtendToolAction = YES;
    self.selectingEmojiAction = NO;
}

- (void)emojiToolAction {
    if (self.selectingEmojiAction) {
        return;
    }
    
    [self.inputTextView resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.inputBarView.frame = CGRectMake(0, self.viewHeight - SREmojiKeyBoardHeight - [self safeAreaHeight] - self.inputBarHeight, SRIMScreenWidth, self.inputBarHeight);
        self.toolView.frame = self.toolViewFrame;
        self.emojiView.frame = CGRectMake(0, self.viewHeight - SREmojiKeyBoardHeight - [self safeAreaHeight], SRIMScreenWidth, SREmojiKeyBoardHeight + [self safeAreaHeight]);
        self.tableView.frame = self.tableViewFrame;
        [self scrollToBottom:NO];
        [self inputBarViewOriginYChanged:self.viewHeight - SREmojiKeyBoardHeight - [self safeAreaHeight] - self.inputBarHeight];
    }];
    
    self.selectingExtendToolAction = NO;
    self.selectingEmojiAction = YES;
}

#pragma mark - Tool

- (void)inputBarViewOriginYChanged:(CGFloat )originY {
    
}

- (void)hideToolButtons {
    self.toolView.frame = self.toolViewFrame;
    self.emojiView.frame = self.emojiKeyBoardFrame;
    self.tableView.frame = self.tableViewFrame;
}
/// 收起键盘和InputView
- (void)hideKeyboardAndInputView {
    
    if (self.keyboardDidShowAlready || self.selectingExtendToolAction || self.selectingEmojiAction) {
        [UIView animateWithDuration:0.5 animations:^{
            if (self.keyboardDidShowAlready) {
                [self.view endEditing:YES];
            }else{
                self.inputBarView.frame = self.inputBarFrame;
                self.emojiView.frame = self.emojiKeyBoardFrame;
                self.toolView.frame = self.toolViewFrame;
            }
            self.tableView.frame = self.tableViewFrame;
            [self scrollToBottom:NO];
            [self inputBarViewOriginYChanged:self.viewHeight - SRInputBarHeight - [self safeAreaHeight]];
        }];
        self.keyboardDidShowAlready = NO;
        self.selectingExtendToolAction = NO;
        self.selectingEmojiAction = NO;
    }
}
- (CGFloat )safeAreaHeight {
    return [self isiPhoneX] ? 34 : 0;
}

#pragma mark - iPhoneX

- (BOOL)isiPhoneX {
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        // 获取底部安全区域高度，iPhone X 竖屏下为 34.0，横屏下为 21.0，其他类型设备都为 0
        CGFloat bottomSafeInset = keyWindow.safeAreaInsets.bottom;
        if (bottomSafeInset == 34.0f || bottomSafeInset == 21.0f) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 子类需要调用or实现的方法

- (NSInteger )notifyUpdateUnreadMessageCount {
    return 0;
}

- (void)sendCustomMessage:(SRBaseContentModel *)chatContent {
    NSDictionary *contentDic = chatContent.mj_keyValues;
    if ([chatContent isKindOfClass:[SRChatContent class]]) {
        NSString *contentStr = [SRIMSerializeExtension jsonStringWithDic:contentDic];
        [self appendMessage:contentStr];
        [self sendMsg:contentStr type:SRIMMessageTypeTxt target_uid:self.target_uid shouldPush:YES];
    }
    else if ([chatContent isKindOfClass:[SRImageContent class]]) {
        NSString *contentStr = [SRIMSerializeExtension jsonStringWithDic:contentDic];
        [self appendImageMessage:contentStr];
        [self sendMsg:contentStr type:SRIMMessageTypeImg target_uid:self.target_uid shouldPush:YES];
    }
    else if ([chatContent isKindOfClass:[SRHouseContent class]]) {
        NSString *contentStr = [SRIMSerializeExtension jsonStringWithDic:contentDic];
        [self appendHouseMessage:contentStr];
        [self sendMsg:contentStr type:SRIMMessageTypeCustom target_uid:self.target_uid shouldPush:YES];
    }
    else {
        if (self.messageClasses.count) {
            for (NSString *messageClass in self.messageClasses) {
                if ([chatContent isKindOfClass:NSClassFromString(messageClass)]) {
                    NSString *contentStr = [SRIMSerializeExtension jsonStringWithDic:contentDic];
                    [self appendCustomizeMessage:chatContent forMessageClass:messageClass];
                    [self sendMsg:contentStr type:SRIMMessageTypeCustom target_uid:self.target_uid shouldPush:YES];
                }
            }
        }
    }
}

- (void)registerCellClass:(Class)cellClass forMessageClass:(Class)messageClass {
    [self.tableView registerClass:cellClass forCellReuseIdentifier:NSStringFromClass(cellClass)];
    if (![self.messageClasses containsObject:NSStringFromClass(messageClass)]) {
        [self.messageClasses addObject:NSStringFromClass(messageClass)];
    }
}

- (void)appendAndDisplayMessage:(SRBaseContentModel *)chatContent {
    if ([chatContent isKindOfClass:[SRChatContent class]]) {
        NSDictionary *contentDic = [SRChatContent mj_keyValues];
        NSString *contentStr = [SRIMSerializeExtension jsonStringWithDic:contentDic];
        [self appendMessage:contentStr];
    }
    else if ([chatContent isKindOfClass:[SRImageContent class]]) {
        NSDictionary *contentDic = [SRImageContent mj_keyValues];
        NSString *contentStr = [SRIMSerializeExtension jsonStringWithDic:contentDic];
        [self appendImageMessage:contentStr];
    }
    else if ([chatContent isKindOfClass:[SRHouseContent class]]) {
        NSDictionary *contentDic = [SRHouseContent mj_keyValues];
        NSString *contentStr = [SRIMSerializeExtension jsonStringWithDic:contentDic];
        [self appendHouseMessage:contentStr];
    }
    else {
        if (self.messageClasses.count) {
            for (NSString *messageClass in self.messageClasses) {
                if ([chatContent isKindOfClass:NSClassFromString(messageClass)]) {
                    SRIMBaseCellViewModel *cellViewModel = [[SRIMBaseCellViewModel alloc] init];
                    cellViewModel.chatModel = [self generateCustomizeMessageWithChatModel:chatContent target_uid:self.target_uid messageClass:messageClass];
                    [self.dataSource addObject:cellViewModel];
                    [self.tableView reloadData];
                    [self scrollToBottom:NO];
                }
            }
        }
        
    }
}

- (SRBaseContentModel *)propertiesWithKeyValues:(NSDictionary *)contentDic {
    Class class = NSClassFromString(self.messageClasses.lastObject);
    if ([class isSubclassOfClass:[SRBaseContentModel class]]) {
        NSObject *object = [class mj_objectWithKeyValues:contentDic];
        return (SRBaseContentModel *)object;
    }
    else {
        return [[SRBaseContentModel alloc] init];
    }
}

- (void)willDisplayMessageCell:(SRChatContentBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat )srIMChatTableView:(UITableView *)tableView sizeForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGFLOAT_MIN;
}

- (SRChatContentBaseCell *)srIMChatTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SRChatContentBaseCell *cell = [[SRChatContentBaseCell alloc] init];
    return cell;
}

- (void)didTapCustomizeCell:(SRBaseContentModel *)model {
    
}

- (void)didTapUrlInChatCell:(NSString *)url {
    
}

- (void)didTapPhoneNumberInChatCell:(NSString *)phoneNumber {
    
}

/// 点击Cell中图片的回调
/// @param imageUrls 当前已拉取到的聊天记录中图片URL数组
/// @param index 点击的ImageCell在数据源中的索引
- (void)presentImagePreviewController:(NSMutableArray *)imageUrls forRowAtIndex:(NSInteger)index {
    
}

- (void)presentImagePreviewCurrent:(NSString *)imageUrl{
    
}

- (void)willSendingMsg:(NSDictionary *)dic{
    
}

- (void)upLoadImgStatus:(SRIMMessageSendStatus)status{
    
}

#pragma mark TableView
- (CGFloat)heightForTableViewHeaderInSection:(NSInteger)section {
    return 0;
}
- (UIView *)viewForTableViewHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = self.configure.chat_bg_color ? self.configure.chat_bg_color : SRIMColorFromRGB(0xf5f5f5);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        //        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[SRChatPrivateCell class] forCellReuseIdentifier:kSRChatPrivateCellIdentifier];
        [_tableView registerClass:[SRHouseContentCell class] forCellReuseIdentifier:kSRHouseContentCellIdentifier];
        [_tableView registerClass:[SRChatImageCell class] forCellReuseIdentifier:kSRImageCellIdentifier];
        MJRefreshNormalHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(historyMessageAction)];
        mj_header.loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        mj_header.stateLabel.hidden = YES;
        mj_header.lastUpdatedTimeLabel.hidden = YES;
        _tableView.mj_header = mj_header;
    }
    return _tableView;
}

- (UIView *)inputBarView {
    if (!_inputBarView) {
        _inputBarView = [[UIView alloc] initWithFrame:self.inputBarFrame];
        _inputBarView.backgroundColor = self.configure.chat_inputBar_bg_color ? self.configure.chat_inputBar_bg_color : SRIMColorFromRGB(0xffffff);
    }
    return _inputBarView;
}

- (UITextView *)inputTextView {
    if (!_inputTextView) {
        _inputTextView = [[UITextView alloc] initWithFrame:self.inputTextFrame];
        _inputTextView.backgroundColor = self.configure.chat_inputBar_inputTextView_bg_color ? self.configure.chat_inputBar_inputTextView_bg_color : [UIColor whiteColor];
        _inputTextView.delegate = self;
        _inputTextView.font = [UIFont systemFontOfSize:16];
        _inputTextView.opaque = NO;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.enablesReturnKeyAutomatically = YES;
        _inputTextView.layer.cornerRadius = 3.f;
        _inputTextView.layer.borderColor = (self.configure.chat_inputBar_inputTextView_broder_color ? self.configure.chat_inputBar_inputTextView_broder_color : SRIMColorFromRGB(0xcccccc)).CGColor;
        _inputTextView.layer.borderWidth = 1;
        _inputTextView.layer.masksToBounds = YES;
        if (self.configure.chat_textview_board_color) {
            _inputTextView.layer.borderColor = self.configure.chat_textview_board_color.CGColor;
            _inputTextView.layer.borderWidth = 1;
        }
    }
    return _inputTextView;
}

- (UIButton *)extentButton {
    if (!_extentButton) {
        _extentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_extentButton setImage:[SRIMImageExtension imageWithName:@"chat_extend"] forState:UIControlStateNormal];
        [_extentButton addTarget:self action:@selector(extendToolAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _extentButton;
}

- (UIButton *)emojiButton {
    if (!_emojiButton) {
        _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emojiButton setImage:[SRIMImageExtension imageWithName:@"chat_emoji"] forState:UIControlStateNormal];
        [_emojiButton addTarget:self action:@selector(emojiToolAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}

- (SRChatToolView *)toolView {
    if (!_toolView) {
        _toolView = [[SRChatToolView alloc] initWithFrame:self.toolViewFrame];
        _toolView.delegate = self;
    }
    return _toolView;
}

- (SREmojiKeyBoard *)emojiView {
    if (!_emojiView) {
        _emojiView = [[SREmojiKeyBoard alloc] initWithFrame:self.emojiKeyBoardFrame];
        _emojiView.backgroundColor = self.configure.chat_detail_emojiKeyBoard_bg_color ? self.configure.chat_detail_emojiKeyBoard_bg_color : SRIMRGB(244, 244, 244);
        _emojiView.delegate = self;
    }
    return _emojiView;
}

- (SRChatTopCloseView *)topCloseView{
    if (!_topCloseView) {
        _topCloseView = [[SRChatTopCloseView alloc]initWithFrame:CGRectMake(0, [self getChatTopViewY], SRIMScreenWidth, SRChatTopViewHeight)];
        __weak typeof(self) weakSelf = self;
        _topCloseView.closeActionBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _topCloseView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)messagesArray {
    if (!_messagesArray) {
        _messagesArray = [[NSMutableArray alloc] init];
    }
    return _messagesArray;
}

- (NSMutableArray *)messageClasses {
    if (!_messageClasses) {
        _messageClasses = [[NSMutableArray alloc] init];
    }
    return _messageClasses;
}

- (CGRect)inputBarFrame{
    return CGRectMake(0, self.viewHeight - SRInputBarHeight - [self safeAreaHeight], SRIMScreenWidth, SRInputBarHeight + [self safeAreaHeight]);
}

- (CGRect)emojiKeyBoardFrame{
    return CGRectMake(0, self.viewHeight, SRIMScreenWidth, SREmojiKeyBoardHeight);
}

- (CGRect)toolViewFrame{
    return CGRectMake(0, self.viewHeight, SRIMScreenWidth, SRChatToolViewHeight);
}

// 这里取相对inpitbarview 位置方便设置tableview偏移
- (CGRect)tableViewFrame{
    if (self.showTopCloseView) {
        return CGRectMake(0, [self getChatTopViewHeightOff], SRIMScreenWidth, self.inputBarView.mj_y - [self getChatTopViewHeightOff]);
    }
    return CGRectMake(0, 0, SRIMScreenWidth, self.inputBarView.mj_y);
}

- (CGRect)inputTextFrame {
    return CGRectMake(5, 5, SRIMScreenWidth - 95, 40);
}

- (CGFloat)getChatTopViewY{
    return 97;
}

- (CGFloat)getChatTopViewHeightOff{
    return [self getChatTopViewY] + SRChatTopViewHeight;
}

- (CGFloat)viewHeight{
    if (_viewHeight == 0) {
        return SRIMScreenHeight;
    }
    return _viewHeight;
}

- (CGFloat)viewHeigthOff{
    return SRIMScreenHeight - self.viewHeight;
}

- (SRIMConfigure *)configure{
    if (!_configure) {
        _configure = [SRIMConfigure shareConfigure];
    }
    return _configure;
}

@end
