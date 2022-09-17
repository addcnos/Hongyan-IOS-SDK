//
//  TWSecurityHeader.h
//  TWSecurityUtil
//
//  Created by addcnos on 2020/7/22.
//

#ifndef TWSecurityHeader_h
#define TWSecurityHeader_h

#define TWSIsNumberClass(reason)   ([reason isKindOfClass:[NSNumber class]])
#define TWSIsDateClass(reason)  ([reason isKindOfClass:[NSDate class]])
#define TWSIsDictionaryClass(reason)  ([reason isKindOfClass:[NSDictionary class]])
#define TWSIsArrayClass(reason)  ([reason isKindOfClass:[NSArray class]])
//字符串化
#define TWSNSNumToNSString(object) (TWSCHECK_NULL(object)?[NSString stringWithFormat:@"%@",object]:@"")
//检查是否为空对象
#define TWSCHECK_NULL(object) ([object isKindOfClass:[NSNull class]]?nil:object)
//空对象 赋予空字符串
#define TWSNullClass(object) (TWSCHECK_NULL(object)?object:@"")

//#define TWSLog(format, ...) printf("DEBUG class: <%s:(%d) > method: %s \n%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#endif /* TWSecurityHeader_h */
