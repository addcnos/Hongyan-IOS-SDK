//
//  SRImageContent.h
//  addcnos
//
//  Created by addcnos on 2019/11/11.
//  Copyright © 2019 addcnos All rights reserved.
//

#import "SRBaseContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRImageContent : SRBaseContentModel

@property (nonatomic, copy) NSString *img_url;

@property (nonatomic, copy) NSString *thumbnail_url;

@property (nonatomic, copy) NSString *extra;

@end

NS_ASSUME_NONNULL_END
