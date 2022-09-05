//
//  NSString+TWSUtil.h
//  TWSecurityTWSUtil
//
//  Created by addcnos on 2020/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (TWSUtil)

/// 字符串去空格
- (NSString *)stringTrimWhitespace;

/// 对一个字符串进行base64编码
- (NSString *)base64EncodeString;

@end

NS_ASSUME_NONNULL_END
