//
//  SRIMConfigure.m
//  AFNetworking
//
//  Created by addcnos on 2019/12/20.
//

#import "SRIMConfigure.h"

@implementation SRIMConfigure

+ (instancetype)shareConfigure {
    static SRIMConfigure *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[SRIMConfigure alloc] init];
    });
    return client;
}


@end
