//
//  ChatListExampleController.m
//  SRIMProject_Example
//
//  Created by addcnos on 2019/12/18.
//  Copyright © 2019 addcnos. All rights reserved.
//

#import "ChatListExampleController.h"
#import "ChatExampleController.h"
#import "UIViewController+HHTransition.h"
@interface ChatListExampleController ()

@end

@implementation ChatListExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (NSMutableArray *)willReloadTableViewDataSource:(NSMutableArray *)dataSource {
    [self.tableView reloadData];
    return self.dataSource;
}

- (void)onSelectedTableViewModel:(SRConversationModel *)conversationModel forRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatExampleController *chatController = [[ChatExampleController alloc] init];
    chatController.target_uid = conversationModel.chatModel.uid;
    chatController.target_name = conversationModel.chatModel.nickname;
    chatController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatController animated:YES];
//    chatController.showTopCloseView = YES;
//    [self.navigationController hh_pushViewController:chatController style:AnimationStyleTopBack];
}

@end
