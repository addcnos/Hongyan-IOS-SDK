## 数睿鸿雁SDK Objective-C文档
![LICENSE](https://img.shields.io/badge/license-MIT-green)
![Language](https://img.shields.io/badge/Language-Objective--C-blue.svg)

#### SDK概述

鸿雁即时通讯是数睿科技公司旗下的一款专注于为开发者提供实时聊天技术和服务的产品。我们的团队来自数睿科技，致力于为用户提供高效稳定的实时聊天云服务，且弹性可扩展，对外提供较为简洁的API接口，让您轻松实现快速集成即时通讯功能

#### 环境依赖

SDK 兼容 iOS9

## 集成流程


#### 1. 引入SDK
SRIMProject可通过 [CocoaPods] 获得([https://cocoapods.org](https://cocoapods.org)). 安装 只需在pod文件中添加以下行：

```ruby
source 'https://github.com/CocoaPods/Specs.git'
source 'https://code.addcn.com/app/iOS/SRIMProjectSpec'
target 'TestDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TestDemo
  pod 'SRIMProject'

end
```

#### 2. 初始化SDK
```objectivec
// 初始化SDK, 注册SDK token
[[SRIMClient shareClient] registerIMServiceWithToken:@"xxxxxx"];
// 设置websocket域名
[SRIMNetworkManager shareManager].socketAPIUrl = xxxxxxxx;
// 设置IM接口域名
[SRIMNetworkManager shareManager].baseAPIUrl = xxxxxxx;
// 断开 IM 链接
[[SRIMClient shareClient] disconnect]; 


// 设置本地通知 
SRLocalNotificationManager *manager = [SRLocalNotificationManager shareManager];
// 默认消息个数
manager.applicationIconBadgeNumber = 0;
// 是否开启本地通知栏 注意：如果需自定义不需设置，否则必须设置YES
manager.isOpenLocationNoti = YES;
// 点击通知栏回调
manager.touchBlock = ^(NSDictionary *userInfo) {
    //点击回调
};
// 通知栏样式 默认样式
manager.managerType = SRLocalNotificationManagerTypeDefault;
// 扩展字段，按不同业务使用，默认可以不加
manager.locationPushExtDic = @{[TWHouseProfessionTool fcmPushStrFromStr:@"cate"]:@"13",
                               [TWHouseProfessionTool fcmPushStrFromStr:@"is_location_push"]:@"1"};

```

#### 3.消息接收监听

```objectivec
// 设置消息回调代理
[SRIMClient shareClient].delegate = self; 

// 实现以下回调代理
/**
 Disconnect 鏈接失敗或者接收消息失敗的回調
 @param errorCode 4006  4004 失效or过期 系统错误
 */
- (void)srIMClient:(SRIMClient *_Nullable)client didReceiveErrorCode:(NSInteger)errorCode;


/**
 Connect 鏈接成功回調
 */
- (void)srIMClientCollectSuccess:(SRIMClient *_Nullable)client messageDic:(NSDictionary *_Nullable)messageDic;

/**
 接受消息成功回調
 
 @param messageType 消息類型
 @param messageDic 文本內容字典
 */
- (void)srIMClient:(SRIMClient *_Nullable)client didReceiveMessage:(SRIMClientMessageType)messageType
        messageDic:(NSDictionary *_Nullable)messageDic;


/**
 鏈接Sockect 失敗回調
 @param error 錯誤
 */
- (void)srIMClient:(SRIMClient *_Nullable)client didFailSocketWithError:(NSError *_Nullable)error;


/**
 sockect即将发起链接
 */
- (void)srIMRegisterClient:(SRIMClient *_Nullable)client;

```

## 方法说明

#### 1.发送消息

```objectivec
/// 发送消息：
- (void)sendMsg:(NSString *)content
           type:(NSString *)type
     target_uid:(NSString *)target_uid
     shouldPush:(BOOL)push
```
| 参数 | 类型 | 说明 |
| --- | --- | --- |
| token | String | 聊天token |
| type | String | 消息的类型 |
| target_uid | String | 聊天目标id |
| content | String | 消息的内容 |
| push | String | 是否推送 |
| successBlock | SRIMSuccessBlock | 发送请求的结果回调监听 |

#### 2.获取历史消息

```objectivec
/// 拉取历史消息：
- (void)fetchHistoricalMsg:(NSString *)link_user
				  node_marker:(NSString *_Nullable )node_marker
				  		 limit:(NSString *_Nullable )limit 
				  		 token:(NSString *)token
```
| 参数 | 类型 | 说明 |
| --- | --- | --- |
| token | String | 聊天token |
| link_user | String | 聊天目标id |
| node_marker | String | 最后一条消息id |
| successBlock | SRIMSuccessBlock | 发送请求的结果回调监听 |

#### 3.发送消息已读

```objectivec
/// 发送消息已读：
- (void)setHadReadMessage
```
| 参数 | 类型 | 说明 |
| --- | --- | --- |
| token | String | 聊天token |
| target_uid | String | 聊天目标id |
| successBlock | SRIMSuccessBlock | 发送请求的结果回调监听 |

#### 4.获取未读消息数

```objectivec
/// 获取聊天列表数据
- (void)loadChatUsers
```
| 参数 | 类型 | 说明 |
| --- | --- | --- |
| token | String | 聊天token |
| page | String | 第几页 |
| successBlock | SRIMSuccessBlock | 发送请求的结果回调监听 |

#### 5.获取会员信息

```objectivec
/// 获取会员信息
- (void)fetchTargetUserInfoWithTargetId:(NSString *)target_uid
```
| 参数 | 类型 | 说明 |
| --- | --- | --- |
| token | String | 聊天token |
| target_uid | String | 聊天目标id |
| successBlock | SRIMSuccessBlock | 发送请求的结果回调监听 |

#### 6.删除联络人

```objectivec
/// 删除联络人
- (void)deleteChatPresonInfoTargetUid:(NSString *)target_uid
```
| 参数 | 类型 | 说明 |
| --- | --- | --- |
| token | String | 聊天token |
| target_uid | String | 聊天目标id |
| successBlock | SRIMSuccessBlock | 发送请求的结果回调监听 |

#### 7.发送图片

```objectivec
/// 上传图片
- (void)uploadImageWithUrl:(NSString * _Nullable )url
                      data:(NSData *_Nullable )data
                     token:(NSString *_Nullable )token
                  filaName:(NSString *_Nullable )fileName
                   success:(SRIMSuccessBlock)successBlock
                   failure:(SRIMFailureBlock )errorBlock
```
| 参数 | 类型 | 说明 |
| --- | --- | --- |
| token | String | 聊天token |
| image | image | 上传的图片文件 |
| successBlock | SRIMSuccessBlock | 发送请求的结果回调监听 |



## 集成即时通讯UI

#### 1.集成聊天界面
自定义页面继承聊天界面 `SRChatController`

```objectivec
// 继承聊天界面 SRChatController
@interface ChatExampleController : SRChatController

@end

@implementation ChatExampleController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 注册自定义的 cell
    [self registerCellClass:[SRChatListExampleIndividualCell class] forMessageClass:[RemindMessageModel class]];
    [self registerCellClass:[CustomizeHouseCell class] forMessageClass:[CustomizeHouseModel class]];
}

#pragma mark - Override
//自定义消息Cell显示
/// @return   自定义消息需要显示的Cell
/// 自定义消息如果需要显示，则必须先通过SRIM的registerCellClass:注册该自定义消息类型，
/// 并在会话页面中通过registerClass:forCellWithReuseIdentifier:注册该自定义消息的Cell，否则将此回调将不会被调用。
- (CGFloat )srIMChatTableView:(UITableView *)tableView sizeForRowAtIndexPath:(NSIndexPath *)indexPath {
	...
}

@end


/// @return  自定义消息Cell需要显示的高度
/// 自定义消息如果需要显示，则必须先通过SRIM的registerCellClass:注册该自定义消息类型，
/// 并在会话页面中通过registerClass:forCellWithReuseIdentifier:注册该自定义消息的Cell，否则此回调将不会被调用。
- (SRChatContentBaseCell *)srIMChatTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	...
}

// 点击物件回调
- (void)didTapCustomizeCell:(SRBaseContentModel *)model {
    
}

// 点击URL回调
- (void)didTapUrlInChatCell:(NSString *)url {
    NSLog(@"url:%@", url);
}

// 点击手机号码回调
- (void)didTapPhoneNumberInChatCell:(NSString *)phoneNumber {
    NSLog(@"phoneNumber:%@", phoneNumber);
}

// 加载到数据是空的, 可以自选处理空数据展示业务
- (void)finishLoadData:(BOOL)isEmpty {
}

// 错误的加载, 可以自选处理错误业务
- (void)failureLoadData:(NSError *)error {
}

```

#### 2.集成消息列表界面

自定义页面继承聊天界面 `SRChatListController`

```objectivec
@interface ChatListExampleController : SRChatListController

@end

@implementation ChatListExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - Override
- (NSMutableArray *)willReloadTableViewDataSource:(NSMutableArray *)dataSource {
    [self.tableView reloadData];
    return self.dataSource;
}

- (void)onSelectedTableViewModel:(SRConversationModel *)conversationModel forRowAtIndexPath:(NSIndexPath *)indexPath {

}

// 加载到数据是空的
- (void)finishLoadData:(BOOL)isEmpty {
}

// 错误的加载
- (void)failureLoadData:(NSError *)error {
}

```


## 版本更新说明

#### v1.4.5 版本
更新日期：2021年1月13日

1. 表情键盘的PageControl适配iOS14，调整验签组件为SRIMNetworkManager子库所依赖
1. 增添属性回调，支持修改应用内推送自定义消息的消息体
1. 设置已读后会发送通知(SRIMDidReceiveChatMessageNotification),可根据需求做些操作
1. 提供方法收起键盘和InputView

#### v1.4.4 版本
更新日期：2020年11月10日

1. 新增消息请求结果回调，调整发送信息失败也需要调用postMessageResult
1. 表情键盘的PageControl适配iOS14

#### v1.4.3 版本
更新日期：2020年10月29日

1. 新增消息请求结果回调
1. 调整发送信息失败也需要调用postMessageResult

#### v1.4.2 版本
更新日期：2020年9月3日

1. 新增聊天详情页TableView的Section Header自定义功能
1. 去除SDWebImage的版本指定（无影响，以主项目中的版本为准）
#### v1.4.1 版本
更新日期：2020年8月27日

1. 新增获取消息未读数获取数据因token而获取失败时触发代理方法

#### v1.4.0 版本
更新日期：2020年8月17日

1. 新增提示功能
1. 完善自定义颜色
1. 调整列表页与对话页的时间显示；修复从对话页返回到列表页后，列表页无法加载下一页数据的bug
1. 列表页获取数据因token而获取失败时触发代理方法

#### v1.3.9 版本
更新日期：2020年7月29日

1. 提供签名校验功能
1. 新增提示功能
1. 提示功能：提示方法新增message参数

#### v1.3.5 版本
更新日期：2020年7月9日

1. 聊天页面发送图片功能开放接口，提供可继承的方法供子类实现，并提供上传图片数组的方法及回调

#### v1.3.4 版本
更新日期：2020年7月1日

1. 聊天详情父类开放文本输入栏动态高度及编辑状态

#### v1.3.0 版本
更新日期：2020年6月29日

1. 为富文本添加超链接点击事件

#### v1.2.0 版本
更新日期：2020年6月3日

1. 移除与UIWebView相关，增加删除联络人
1. 消息列表新增自定义消息会话类型Cell，以及对应的编辑类型
1. 消息列表数据源刷新方法触发条件改为只有第1页的时候才触发
1. 消息列表数据源上拉加载更多刷新方法触发机制修改
1. 消息详情父页面添加自定义消息发送完成的方法供子类重写，以及文本消息为文本内容添加交互（如超链接点击等）
1. 解决属性和文件方法名冲突
1. 聊天详情父类暴露文本输入栏

#### v1.1.8 版本
更新日期：2020年5月6日

1. bug修复，过滤聊天消息返回字段类型不匹配问题

#### v1.1.5 版本
更新日期：2020年3月18日

1. 增加动态配置域名

#### v1.1.4 版本
更新日期：2020年3月17日

1. IM-SDK代码功能优化 && bug 修复

#### v1.1.0 版本
更新日期：2020年3月5日

1. 支持IM-SDK基础功能


## 相关资料

#### [数睿鸿雁后端服务文档](https://github.com/addcnos/Hongyan-Server)
#### [数睿鸿雁SDK-flutter文档](https://github.com/addcnos/Hongyan-Flutter-SDK)
#### [数睿鸿雁SDK-Android文档](https://github.com/addcnos/Hongyan-Android-SDK)
#### [数睿鸿雁SDK-Objective-C文档](https://github.com/addcnos/Hongyan-IOS-SDK)
#### [数睿鸿雁SDK-Web文档](https://github.com/addcnos/Hongyan-Web-SDK)
