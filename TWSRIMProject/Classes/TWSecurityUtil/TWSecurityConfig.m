//
//  TWSecurityConfig.m
//  TWSecurityUtil
//
//  Created by linxunfeng on 2020/7/22.
//

#import "TWSecurityConfig.h"

@implementation TWSecurityConfig

- (instancetype)init {
    if (self = [super init]) {
        // 设置默认刷新时间为1小时
        self.refreshTime = 3600;
        self.saveServiceTimeKey = @"TWDef_ServiceTime";
    }
    return self;
}

@end
