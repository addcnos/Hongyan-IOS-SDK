//
//  RemindMessageModel.h
//  SRIMProject_Example
//
//  Created by Addcnhk591 on 2019/12/19.
//  Copyright © 2019 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
//

#import <SRIMProject/SRIMProject.h>

NS_ASSUME_NONNULL_BEGIN

@interface RemindMessageModel : SRBaseContentModel<NSCoding>

@property (nonatomic, copy) NSString *remindStr;

@property (nonatomic, copy) NSString *time;

@end

NS_ASSUME_NONNULL_END
