//
//  SRIMImageExtension.m
//  SRIM
//
//  Created by addcnos on 2019/12/4.
//  Copyright © 2019 addcnos. All rights reserved.
//

#import "SRIMImageExtension.h"

@implementation NSBundle (SRIM)
+ (instancetype)SRIMBundle {
    static NSBundle *refreshBundle = nil;
    if (refreshBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        NSBundle *bundle = [NSBundle bundleForClass:[SRIMImageExtension class]];
        refreshBundle = [NSBundle bundleWithPath:[bundle pathForResource:@"TWSRIMProject" ofType:@"bundle"]];
//        NSLog(@"bundle ==> %@, refreshBundle => %@",bundle,refreshBundle);
    }
    return refreshBundle;
}

@end

@implementation SRIMImageExtension

+ (UIImage *)imageWithName:(NSString *)imageName {
    NSBundle *bundle = [NSBundle SRIMBundle];
    NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%@@2x",imageName] ofType:@"png"];
    UIImage *image = [[UIImage imageWithContentsOfFile:path] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

+ (NSArray *)emojiArrWithName:(NSString *)fileName {
    NSBundle *bundle = [NSBundle SRIMBundle];
    NSString *plistPath = [bundle pathForResource:@"SRIMEmoji" ofType:@"plist"];
    NSArray *emojiArr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    if (emojiArr.count == 0) {
        return [@[] copy];
    }
    return emojiArr;
}

+ (NSData *)smartCompressImage:(UIImage *)image {
    int width = (int)image.size.width;
    int height = (int)image.size.height;
    int updateWidth = width;
    int updateHeight = height;
    int longSide = MAX(width, height);
    int shortSide = MIN(width, height);
    float scale = ((float)shortSide / longSide);
    if (longSide < 1080) {
        updateWidth = width;
        updateHeight = height;
    }
    else {
        if (width <= height) {
            updateWidth = 1080 * scale;
            updateHeight = 1080;
        }
        else {
            updateWidth = 1080;
            updateHeight = 1080 * scale;
        }
    }
    CGSize compressSize = CGSizeMake(updateWidth, updateHeight);
    UIGraphicsBeginImageContext(compressSize);
    [image drawInRect:CGRectMake(0, 0, compressSize.width, compressSize.height)];
    UIImage *compressImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *compressData = UIImageJPEGRepresentation(compressImage, 0.3);
    return compressData;
}

@end
