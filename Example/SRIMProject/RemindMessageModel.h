//
//  RemindMessageModel.h
//  SRIMProject_Example
//
//  Created by addcnos on 2019/12/19.
//  Copyright © 2019 addcnos. All rights reserved.
//

#import <TWSRIMProject/SRIMProject.h>

NS_ASSUME_NONNULL_BEGIN

@interface RemindMessageModel : SRBaseContentModel<NSCoding>

@property (nonatomic, copy) NSString *remindStr;

@property (nonatomic, copy) NSString *time;

@end

NS_ASSUME_NONNULL_END
