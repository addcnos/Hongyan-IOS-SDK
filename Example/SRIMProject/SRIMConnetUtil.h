//
//  SRIMConnetUtil.h
//  SRIMProject_Example
//
//  Created by zhengzeqin on 2019/12/18.
//  Copyright © 2019 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRIMConnetUtil : NSObject
+ (instancetype)shareClient;
- (void)registerIMServiceWithIdcode:(NSString *)idcode;
@end

NS_ASSUME_NONNULL_END
