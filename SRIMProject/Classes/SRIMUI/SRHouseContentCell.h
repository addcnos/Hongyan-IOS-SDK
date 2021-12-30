//
//  SRHouseContentCell.h
//  HKHouse591
//
//  Created by shuxiao on 2019/9/22.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRChatContentBaseCell.h"
#import "SRHouseContentCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HouseTapBlock)(void);

@interface SRHouseContentCell : SRChatContentBaseCell

@property (nonatomic, strong) UILabel *nickNameLabel;

@property (nonatomic, strong) UIView *contentBGView;

//封面圖
@property (weak, nonatomic) UIImageView *coverView;
//標題
@property (weak, nonatomic) UILabel *title;
//格局+坪數
@property (weak, nonatomic) UILabel *address;
//價格
@property (weak, nonatomic) UILabel *price;
//單位
@property (weak, nonatomic) UILabel *price_unit;

@property (nonatomic, strong) SRHouseContentCellViewModel *cellViewModel;

@property (nonatomic, copy) HouseTapBlock block;

@end

NS_ASSUME_NONNULL_END
