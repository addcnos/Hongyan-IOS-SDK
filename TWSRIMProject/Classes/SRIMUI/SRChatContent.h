//
//  SRChatContent.h
//  addcnos
//
//  Created by addcnos on 2019/9/20.
//  Copyright © 2019 addcnos All rights reserved.
//

#import "SRBaseContentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRChatContent : SRBaseContentModel

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *extra;

@end

NS_ASSUME_NONNULL_END
