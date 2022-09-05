//
//  RemindMessageModel.m
//  SRIMProject_Example
//
//  Created by addcnos on 2019/12/19.
//  Copyright © 2019 addcnos. All rights reserved.
//

#import "RemindMessageModel.h"

@implementation RemindMessageModel

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.remindStr forKey:@"remindStr"];
    [coder encodeObject:self.time forKey:@"time"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.remindStr = [coder decodeObjectForKey:@"remindStr"];
        self.time = [coder decodeObjectForKey:@"time"];
    }
    return self;
}

@end
