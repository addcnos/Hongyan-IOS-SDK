//
//  SRIMNetworkManagerHeader.h
//  SRIMProject
//
//  Created by addcnos on 2020/7/24.
//

#ifndef SRIMNetworkManagerHeader_h
#define SRIMNetworkManagerHeader_h

// 参数签名方式
typedef enum : NSUInteger {
    SRIMSignatureParamsTypeNone, // 不签名(默认)
    SRIMSignatureParamsTypeSRIM, // SRIM的签名方式
} SRIMSignatureParamsType;

typedef enum : NSUInteger {
    SRIMNetworkIMCodeTypeSuccess = 200, // 请求成功
    SRIMNetworkIMCodeTypeBlacklistNoSendMsg = 4011, // 被拉黑名单，不能发消息
} SRIMNetworkIMCodeType;

#endif /* SRIMNetworkManagerHeader_h */

