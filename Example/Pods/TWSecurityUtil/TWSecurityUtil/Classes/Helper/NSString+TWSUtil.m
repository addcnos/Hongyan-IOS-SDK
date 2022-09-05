//
//  NSString+TWSUtil.m
//  TWSecurityTWSUtil
//
//  Created by addcnos on 2020/7/22.
//

#import "NSString+TWSUtil.h"

@implementation NSString (TWSUtil)

/// 字符串去空格
- (NSString *)stringTrimWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

/// 对一个字符串进行base64编码
- (NSString *)base64EncodeString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

@end
