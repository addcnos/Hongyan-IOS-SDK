//
//  CustomizeHouseModel.h
//  SRIMProject_Example
//
//  Created by Addcnhk591 on 2019/12/30.
//  Copyright © 2019 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
//

#import <SRIMProject/SRIMProject.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomizeHouseModel : SRBaseContentModel<NSCoding>

/**
 消息的内容
 */
@property (nonatomic, strong) NSString *shareContent;

/**
 列表頁備註
 */
@property (nonatomic, strong) NSString *note;

/**
 封面圖
 */
@property (nonatomic, strong) NSString *icon;

/**
 標題
 */
@property (nonatomic, strong) NSString *title;

/**
 格局+坪數
 */
@property (nonatomic, strong) NSString *address;

/**
 價格
 */
@property (nonatomic, strong) NSString *price;

/**
 單位
 */
@property (nonatomic, strong) NSString *price_unit;

/**
 ID
 */
@property (nonatomic, strong) NSString *houseId;

/**
 跳转地址
 */
@property (nonatomic, strong) NSString *linkUrl;

/**
 跳转方式
 */
@property (nonatomic, strong) NSString *jump;

@property (nonatomic, assign) NSInteger is_refresh;

@property (nonatomic, assign) NSInteger state;



@end

NS_ASSUME_NONNULL_END
