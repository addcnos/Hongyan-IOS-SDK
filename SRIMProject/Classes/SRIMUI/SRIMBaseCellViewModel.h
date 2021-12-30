//
//  SRIMBaseCellViewModel.h
//  Pods
//
//  Created by Addcnhk591 on 2019/12/18.
//

#import <Foundation/Foundation.h>

@class SRChatModel;
NS_ASSUME_NONNULL_BEGIN

@interface SRIMBaseCellViewModel : NSObject

@property (nonatomic, strong) SRChatModel *chatModel;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *token;

- (void)updateUserInfo:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
