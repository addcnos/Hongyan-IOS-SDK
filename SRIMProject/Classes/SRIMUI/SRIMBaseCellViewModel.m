//
//  SRIMBaseCellViewModel.m
//  Pods
//
//  Created by Addcnhk591 on 2019/12/18.
//

#import "SRIMBaseCellViewModel.h"

@implementation SRIMBaseCellViewModel

- (void)updateUserInfo:(NSDictionary *)userInfo {
    self.avatar = userInfo[@"avatar"];
    self.uid = userInfo[@"uid"] ;
    self.nickname = userInfo[@"nickname"];
    self.token = userInfo[@"token"];
}

@end
