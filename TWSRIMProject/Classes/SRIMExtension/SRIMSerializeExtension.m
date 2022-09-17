//
//  SRIMSerializeExtension.m
//  SRIM
//
//  Created by addcnos on 2019/12/4.
//  Copyright © 2019 addcnos. All rights reserved.
//

#import "SRIMSerializeExtension.h"

@implementation SRIMSerializeExtension

#pragma mark - Dictionary转Json

+ (NSString *)jsonStringWithDic:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;

    if (!jsonData) {
        NSLog(@"%@",error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

#pragma mark - String转Dic

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return nil;
    }
    return dic;
}

@end
