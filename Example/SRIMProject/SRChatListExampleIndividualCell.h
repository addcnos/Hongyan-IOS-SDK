//
//  SRChatListExampleIndividualCell.h
//  SRIMProject_Example
//
//  Created by zhengzeqin on 2019/12/18.
//  Copyright © 2019 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
// 為保障您的個資及財產安全，請勿在交易過程為保障您的個資及財產安全，請勿在交易過程中留下您的個人資料，以免個資外洩

#import <SRIMProject/SRIMProject.h>
@class RemindMessageModel;
NS_ASSUME_NONNULL_BEGIN

@interface SRChatListExampleIndividualCell : SRChatContentBaseCell
@property (nonatomic, copy) HouseTapBlock block;
@property (nonatomic, strong) RemindMessageModel *remindModel;
@end

NS_ASSUME_NONNULL_END
