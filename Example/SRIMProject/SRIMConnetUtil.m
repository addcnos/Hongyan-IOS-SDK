//
//  SRIMConnetUtil.m
//  SRIMProject_Example
//
//  Created by addcnos on 2019/12/18.
//  Copyright © 2019 addcnos. All rights reserved.
//

#import "SRIMConnetUtil.h"
#import <TWSRIMProject/SRIMProject.h>
#import "SRIMDemoHeader.h"
@implementation SRIMConnetUtil

+ (instancetype)shareClient {
    static SRIMConnetUtil *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[SRIMConnetUtil alloc] init];
    });
    return client;
}

- (void)cleanIMToken:(NSString *)idCode {
    NSDictionary *param = @{@"idcode":idCode};
    [[SRIMNetworkManager shareManager] loadDataWithUrl:SRIMCleanToken method:@"GET" parameters:param success:^(id  _Nonnull responseObject) {
        [self registerIMServiceWithIdcode:idCode];
    } failureBlock:^(NSError * _Nonnull error) {
        //
    }];
}

- (void)registerIMServiceWithIdcode:(NSString *)idcode {
    if (!idcode || [idcode isEqual:[NSNull null]] || idcode.length == 0) {
        NSAssert(idcode, @"idcode不可为空");
        return;
    }
    NSDictionary *param = @{@"idcode": idcode};
    [[SRIMNetworkManager shareManager] loadDataWithUrl:SRIMGetToken method:@"GET" parameters:param success:^(id  _Nonnull responseObject) {
        NSDictionary *responseDic = responseObject;
        NSLog(@"Get IM success:%@", responseDic);
        NSString *token = responseDic[@"data"][@"token"];
        if (responseDic[@"data"][@"user_im_info"]) {
            NSDictionary *userInfo = responseDic[@"data"][@"user_im_info"];
            if (userInfo[@"uid"]) {
                NSString *uid = [NSString stringWithFormat:@"%@", userInfo[@"uid"]];
                [self saveUserId:uid];
            }
        }
        NSLog(@"token:%@", token);
        [[SRIMClient shareClient] saveToken:token];
        [[SRIMClient shareClient] registerIMServiceWithToken:token];
        
    } failureBlock:^(NSError * _Nonnull error) {
        if (error.code == 4004 || error.code == 4006) {
            //Token 失效
            [self cleanIMToken:idcode];
        }
        else if (error.code > 1000) {
            
        }
    }];
}

- (void)saveUserId:(NSString *)uid {
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"SRIMUserIdKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeUseId {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SRIMUserIdKey"];
}

- (NSString *)getUid {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"SRIMUserIdKey"];
}

@end
