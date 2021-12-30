//
//  SRImageContent.h
//  HKHouse591
//
//  Created by Addcnhk591 on 2019/11/11.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRBaseContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRImageContent : SRBaseContentModel

@property (nonatomic, copy) NSString *img_url;

@property (nonatomic, copy) NSString *thumbnail_url;

@property (nonatomic, copy) NSString *extra;

@end

NS_ASSUME_NONNULL_END
