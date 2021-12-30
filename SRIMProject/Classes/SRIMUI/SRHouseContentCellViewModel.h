//
//  SRHouseContentCellViewModel.h
//  HKHouse591
//
//  Created by addcn591 on 2019/9/23.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRIMBaseCellViewModel.h"
#import "SRChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRHouseContentCellViewModel : SRIMBaseCellViewModel

- (instancetype)initWithChatModel:(SRChatModel *)chatModel;

- (CGFloat )cellHeight;

@end

NS_ASSUME_NONNULL_END
