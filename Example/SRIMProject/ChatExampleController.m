//
//  ChatExampleController.m
//  SRIMProject_Example
//
//  Created by Addcnhk591 on 2019/12/18.
//  Copyright © 2019 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
//

#import "ChatExampleController.h"
#import "SRChatListExampleIndividualCell.h"
#import "RemindMessageModel.h"
#import "CustomizeHouseCell.h"
#import "CustomizeHouseModel.h"
#import <UITableView+FDTemplateLayoutCell.h>

@interface ChatExampleController ()

@property (nonatomic, strong) RemindMessageModel *remindModel;

@end

@implementation ChatExampleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerCellClass:[SRChatListExampleIndividualCell class] forMessageClass:[RemindMessageModel class]];
    [self registerCellClass:[CustomizeHouseCell class] forMessageClass:[CustomizeHouseModel class]];
    RemindMessageModel *model = [[RemindMessageModel alloc] init];
    model.remindStr = @"為保障您的個資及財產安全，請勿在交易過程為保障您的個資及財產安全，請勿在交易過程中留下您的個人資料，以免個資外洩";
    model.time = @"2019-12-19";
    self.remindModel = model;
    [self appendAndDisplayMessage:model];
    
    
    CustomizeHouseModel *houseModel = [[CustomizeHouseModel alloc] init];
    houseModel.address = @"1带来欢乐的可能";
    houseModel.houseId = @"R686524";
    houseModel.icon = @"https://www.debug.591.com.hk/Public/Static/images/rongcloud_default2.png";
    houseModel.is_refresh = 0;
    houseModel.linkUrl = @"https://rent.debug.591.com.hk/rent-detail-686524.html?z=1_4_1_1";
    houseModel.note = @"";
    houseModel.price = @"2222";
    houseModel.price_unit = @"元/平";
    houseModel.shareContent = @"老大给你了可是奶粉个拉米雷斯麻烦";
    houseModel.state = 1;
    houseModel.title = @"我是标题";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self sendCustomMessage:houseModel];
    });
    
}

- (SRBaseContentModel *)propertiesWithKeyValues:(NSDictionary *)contentDic {
    CustomizeHouseModel *model = [[CustomizeHouseModel alloc] init];
    if (!contentDic || contentDic.allKeys.count == 0 || [contentDic isKindOfClass:[NSArray class]]) {
        return model;
    }
    model.address = contentDic[@"address"] ? : [NSNull null];
    model.shareContent = contentDic[@"shareContent"] ? : [NSNull null];
    model.note = contentDic[@"note"] ? : [NSNull null];
    model.icon = contentDic[@"icon"] ? : [NSNull null];
    model.title = contentDic[@"title"] ? : [NSNull null];
    model.price = contentDic[@"price"] ? : [NSNull null];
    model.price_unit = contentDic[@"price_unit"] ? : [NSNull null];
    model.houseId = contentDic[@"houseId"] ? : [NSNull null];
    model.linkUrl = contentDic[@"linkUrl"] ? : [NSNull null];
    model.jump = contentDic[@"jump"] ? : [NSNull null];
    model.is_refresh = contentDic[@"is_refresh"] ? [contentDic[@"is_refresh"] integerValue]: 0;
    model.state = contentDic[@"state"] ? [contentDic[@"state"] integerValue]: 0;
    return model;
}

- (void)willDisplayMessageCell:(SRChatContentBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)srIMChatTableView:(UITableView *)tableView sizeForRowAtIndexPath:(NSIndexPath *)indexPath {
    SRIMBaseCellViewModel *cellViewModel = (SRIMBaseCellViewModel *)[self.dataSource objectAtIndex:indexPath.row];
    if ([cellViewModel.chatModel.content isKindOfClass:[RemindMessageModel class]]) {
        return 70;
    }
    else if ([cellViewModel.chatModel.content isKindOfClass:[CustomizeHouseModel class]]) {
        CGFloat height = [tableView fd_heightForCellWithIdentifier:NSStringFromClass([CustomizeHouseCell class]) cacheByIndexPath:indexPath configuration:^(CustomizeHouseCell *cell) {
            cell.cellViewModel = cellViewModel;
        }];
        return height;
    }
    return CGFLOAT_MIN;
}

- (SRChatContentBaseCell *)srIMChatTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SRIMBaseCellViewModel *cellViewModel = (SRIMBaseCellViewModel *)[self.dataSource objectAtIndex:indexPath.row];
    if ([cellViewModel.chatModel.content isKindOfClass:[RemindMessageModel class]]) {
        SRChatListExampleIndividualCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SRChatListExampleIndividualCell class]) forIndexPath:indexPath];
        cell.remindModel = (RemindMessageModel *)cellViewModel.chatModel.content;
        return cell;
    }
    else if ([cellViewModel.chatModel.content isKindOfClass:[CustomizeHouseModel class]]) {
        CustomizeHouseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CustomizeHouseCell class]) forIndexPath:indexPath];
        cell.cellViewModel = cellViewModel;
        return cell;
    }
    return nil;
}

#pragma mark - 点击物件回调

- (void)didTapCustomizeCell:(SRBaseContentModel *)model {
    
}

#pragma mark - 点击URL回调

- (void)didTapUrlInChatCell:(NSString *)url {
    NSLog(@"url:%@", url);
}

#pragma mark - 点击手机号码回调

- (void)didTapPhoneNumberInChatCell:(NSString *)phoneNumber {
    NSLog(@"phoneNumber:%@", phoneNumber);
}

@end
