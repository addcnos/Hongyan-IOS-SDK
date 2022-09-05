//
//  SRIMDemoHeader.h
//  SRIMProject
//
//  Created by addcnos on 2019/12/17.
//  Copyright © 2019 addcnos. All rights reserved.
//

#ifndef SRIMDemoHeader_h
#define SRIMDemoHeader_h


/**
 IM Service注册
 */
#define SRIMServiceURL @"https://service.debug.example.com" //@"https://service.example.com"

#define SRIMRegisterToken [SRIMServiceURL stringByAppendingString:@"/api/Im/register"]

#define SRIMGetToken [SRIMServiceURL stringByAppendingString:@"/api/Im/getToken"]

#define SRIMCleanToken [SRIMServiceURL stringByAppendingString:@"/api/Im/cleanToken"]

#define SRIMGetConversationUserInfo [SRIMServiceURL stringByAppendingString:@"/api/Im/getConversationUserInfo"]

#endif /* SRIMDemoHeader_h */
