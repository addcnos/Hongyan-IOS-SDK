//
//  SRChatPrivateCellViewModel.h
//  HKHouse591
//
//  Created by addcn591 on 2019/9/23.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRIMBaseCellViewModel.h"
#import "SRChatModel.h"
#import "SRIMUtility.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRChatPrivateCellViewModel : SRIMBaseCellViewModel

- (instancetype)initWithChatModel:(SRChatModel *)chatModel;

- (CGRect )contentBGFrame;

- (CGFloat )contentWidth;

- (CGFloat )cellHeight;

- (NSString *)contentString;

- (NSString *)createTime;

- (NSString *)from_uid;

- (NSString *)msg_id;

- (NSString *)sendTime;

- (NSInteger )message_direction;

- (NSString *)targetUid;

- (NSString *)messageType;

- (NSInteger )status;

@end

NS_ASSUME_NONNULL_END
