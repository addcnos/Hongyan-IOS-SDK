//
//  SRChatContent.h
//  HKHouse591
//
//  Created by addcn591 on 2019/9/20.
//  Copyright © 2019 com.addcn.hk591. All rights reserved.
//

#import "SRBaseContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRChatContent : SRBaseContentModel

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *extra;

@end

NS_ASSUME_NONNULL_END
