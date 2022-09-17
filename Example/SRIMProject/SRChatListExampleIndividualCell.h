//
//  SRChatListExampleIndividualCell.h
//  SRIMProject_Example
//
//  Created by addcnos on 2019/12/18.
//  Copyright © 2019 addcnos. All rights reserved.
// 為保障您的個資及財產安全，請勿在交易過程為保障您的個資及財產安全，請勿在交易過程中留下您的個人資料，以免個資外洩

#import <TWSRIMProject/SRIMProject.h>
@class RemindMessageModel;
NS_ASSUME_NONNULL_BEGIN

@interface SRChatListExampleIndividualCell : SRChatContentBaseCell
@property (nonatomic, copy) HouseTapBlock block;
@property (nonatomic, strong) RemindMessageModel *remindModel;
@end

NS_ASSUME_NONNULL_END
