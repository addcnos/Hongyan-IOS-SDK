//
//  SRIMSerializeExtension.h
//  SRIM
//
//  Created by Addcnhk591 on 2019/12/4.
//  Copyright © 2019 Addcnhk591. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRIMSerializeExtension : NSObject

+ (NSString *)jsonStringWithDic:(NSDictionary *)dic;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
