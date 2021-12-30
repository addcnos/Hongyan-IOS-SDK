//
//  SRIMDemoHeader.h
//  SRIMProject
//
//  Created by zhengzeqin on 2019/12/17.
//  Copyright © 2019 acct<blob>=0xE69D8EE69993E696B9. All rights reserved.
//

#ifndef SRIMDemoHeader_h
#define SRIMDemoHeader_h


/**
 IM Service注册
 */
#define SRIMServiceURL @"https://service.debug.591.com.hk" //@"https://service.591.com.hk"

#define SRIMRegisterToken [SRIMServiceURL stringByAppendingString:@"/api/Im/register"]

#define SRIMGetToken [SRIMServiceURL stringByAppendingString:@"/api/Im/getToken"]

#define SRIMCleanToken [SRIMServiceURL stringByAppendingString:@"/api/Im/cleanToken"]

#define SRIMGetConversationUserInfo [SRIMServiceURL stringByAppendingString:@"/api/Im/getConversationUserInfo"]

#endif /* SRIMDemoHeader_h */
