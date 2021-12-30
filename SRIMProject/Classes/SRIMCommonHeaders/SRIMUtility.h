//
//  SRIMUtility.h
//  SRIM
//
//  Created by Addcnhk591 on 2019/12/3.
//  Copyright © 2019 Addcnhk591. All rights reserved.
//

#ifndef SRIMUtility_h
#define SRIMUtility_h

#import <Masonry/Masonry.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//例 ffffff 前面加0x SRIMColorFromRGB(0xffffff)
#define SRIMColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define SRIMRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define SRIMRandomColor [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1]

#define SRIMScreenRect [[UIScreen mainScreen] bounds]
#define SRIMScreenWidth [UIScreen mainScreen].bounds.size.width
#define SRIMScreenHeight [UIScreen mainScreen].bounds.size.height

//检查是否为空对象
#define SRIMCHECK_NULL(object) ([object isKindOfClass:[NSNull class]]?nil:object)
//空对象 赋予空字符串
#define SRIMNullClass(object) (SRIMCHECK_NULL(object)?object:@"")
#define SRIMIsStrClass(reason)   ([reason isKindOfClass:[NSString class]])
#define SRIMIsNumberClass(reason)   ([reason isKindOfClass:[NSNumber class]])
#define SRIMIsArrayClass(reason)  ([reason isKindOfClass:[NSArray class]])
#define SRIMIsDateClass(reason)  ([reason isKindOfClass:[NSDate class]])
#define SRIMIsDictionaryClass(reason)  ([reason isKindOfClass:[NSDictionary class]])


//防止block循環引用
#define SRIMWeakSelf(weakSelf) __weak __typeof(&*self)weakSelf = self;

#ifdef DEBUG
/******DEBUG 输出********/
#define SRIMLog(format, ...) printf("DEBUG class: <%s:(%d) > method: %s \n%s\n", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )

#else
/******线上 输出********/
#define SRIMLog(...)
#endif

#endif /* SRIMUtility_h */
