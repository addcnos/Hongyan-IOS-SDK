//
//  SRIMImageExtension.h
//  SRIM
//
//  Created by addcnos on 2019/12/4.
//  Copyright © 2019 addcnos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SRIMImageExtension : NSObject

/// 仿微信图片压缩算法
/// @param image original image
+ (NSData *)smartCompressImage:(UIImage *)image;

+ (UIImage *)imageWithName:(NSString *)imageName;

/// 根据emoji文件名找到对应的emoji数组
/// @param fileName plist文件名
+ (NSArray *)emojiArrWithName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
