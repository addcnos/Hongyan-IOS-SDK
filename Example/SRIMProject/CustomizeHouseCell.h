//
//  CustomizeHouseCell.h
//  SRIMProject_Example
//
//  Created by Addcnhk591 on 2019/12/30.
//  Copyright © 2019 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
//

#import <SRIMProject/SRIMProject.h>
#import "CustomizeHouseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomizeHouseCell : SRChatContentBaseCell

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

@property (nonatomic, strong) SRIMBaseCellViewModel *cellViewModel;
@end

NS_ASSUME_NONNULL_END
