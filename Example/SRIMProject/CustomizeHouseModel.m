//
//  CustomizeHouseModel.m
//  SRIMProject_Example
//
//  Created by Addcnhk591 on 2019/12/30.
//  Copyright © 2019 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
//

#import "CustomizeHouseModel.h"

@implementation CustomizeHouseModel

//+ (instancetype)propertiesWithKeyValues:(NSDictionary *)dic {
//    CustomizeHouseModel *model = [[CustomizeHouseModel alloc] init];
//    if (!dic || dic.allKeys.count == 0) {
//        return model;
//    }
//    if (dic && dic.allKeys.count) {
//        model.address = dic[@"address"] ? : [NSNull null];
//        model.shareContent = dic[@"shareContent"] ? : [NSNull null];
//        model.note = dic[@"note"] ? : [NSNull null];
//        model.icon = dic[@"icon"] ? : [NSNull null];
//        model.title = dic[@"title"] ? : [NSNull null];
//        model.price = dic[@"price"] ? : [NSNull null];
//        model.price_unit = dic[@"price_unit"] ? : [NSNull null];
//        model.houseId = dic[@"houseId"] ? : [NSNull null];
//        model.linkUrl = dic[@"linkUrl"] ? : [NSNull null];
//        model.jump = dic[@"jump"] ? : [NSNull null];
//        model.is_refresh = dic[@"is_refresh"] ? [dic[@"is_refresh"] integerValue]: 0;
//        model.state = dic[@"state"] ? [dic[@"state"] integerValue]: 0;
//    }
//    return model;
//}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.shareContent forKey:@"shareContent"];
    [coder encodeObject:self.note forKey:@"note"];
    [coder encodeObject:self.icon forKey:@"icon"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.address forKey:@"address"];
    [coder encodeObject:self.price forKey:@"price"];
    [coder encodeObject:self.price_unit forKey:@"price_unit"];
    [coder encodeObject:self.houseId forKey:@"houseId"];
    [coder encodeObject:self.linkUrl forKey:@"linkUrl"];
    [coder encodeObject:self.jump forKey:@"jump"];
    [coder encodeInteger:self.is_refresh forKey:@"is_refresh"];
    [coder encodeInteger:self.state forKey:@"state"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.note = [coder decodeObjectForKey:@"note"];
        self.shareContent = [coder decodeObjectForKey:@"shareContent"];
        self.icon = [coder decodeObjectForKey:@"icon"];
        self.title = [coder decodeObjectForKey:@"title"];
        self.address = [coder decodeObjectForKey:@"address"];
        self.price = [coder decodeObjectForKey:@"price"];
        self.price_unit = [coder decodeObjectForKey:@"price_unit"];
        self.houseId = [coder decodeObjectForKey:@"houseId"];
        self.linkUrl = [coder decodeObjectForKey:@"linkUrl"];
        self.jump = [coder decodeObjectForKey:@"jump"];
        self.is_refresh = [coder decodeIntegerForKey:@"is_refresh"];
        self.state = [coder decodeIntegerForKey:@"state"];
    }
    return self;
}

@end
