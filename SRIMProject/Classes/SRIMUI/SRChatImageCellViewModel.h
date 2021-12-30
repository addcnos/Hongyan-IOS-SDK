//
//  SRChatImageCellViewModel.h
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/11/11.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRIMBaseCellViewModel.h"
#import <UIKit/UIKit.h>
#import "SRChatModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRChatImageCellViewModel : SRIMBaseCellViewModel

- (instancetype)initWithChatModel:(SRChatModel *)chatModel;

- (CGFloat )cellHeight;

@end

NS_ASSUME_NONNULL_END
