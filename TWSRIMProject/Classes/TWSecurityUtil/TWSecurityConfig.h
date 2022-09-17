//
//  TWSecurityConfig.h
//  TWSecurityUtil
//
//  Created by linxunfeng on 2020/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TWSecurityConfig : NSObject

/** appId */
@property (nonatomic, copy) NSString *appId;
/** secret */
@property (nonatomic, copy) NSString *secret;
/** 时间，单位：秒（默认是1小时，用于 存储的时间戳有效期 和 刷新时间的定时器） */
@property (nonatomic, assign) NSTimeInterval refreshTime;
/** 是否为调试模式，如果是则打印信息 */
@property (nonatomic, assign) BOOL isDebug;

/** 存储服务器时间戳的 user default key （默认值: TWDef_ServiceTime） */
@property (nonatomic, copy) NSString *saveServiceTimeKey;

#pragma mark - Private
// 以下仅组件内部使用
/** 服务器时间与本地时间的差值 */
@property (nonatomic, strong) NSNumber *localCulNumberMinusServerTime;
/** 定时器 */
@property (nonatomic, strong) dispatch_source_t timer;

@end

NS_ASSUME_NONNULL_END
