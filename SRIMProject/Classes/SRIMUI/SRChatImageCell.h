//
//  SRChatImageCell.h
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/11/6.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRChatContentBaseCell.h"

@class SRChatImageCellViewModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^ImageBlock)(SRChatImageCellViewModel *cellViewModel);

@interface SRChatImageCell : SRChatContentBaseCell

@property (nonatomic, copy) ImageBlock imageBlock;

@property (nonatomic, strong) UIImageView *imageContentView;

@property (nonatomic, strong) SRChatImageCellViewModel *cellViewModel;

@end

NS_ASSUME_NONNULL_END
