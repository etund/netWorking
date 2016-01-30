//
//  AIFNetworkingConfiguration.h
//  PywSdk
//
//  Created by yunyoufeitian on 16/1/20.
//  Copyright © 2016年 zero. All rights reserved.
//

#ifndef AIFNetworkingConfiguration_h
#define AIFNetworkingConfiguration_h

typedef NS_ENUM(NSUInteger, AIFURLResponseStatus)
{
    AIFURLResponseStatusSuccess, //作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的RTApiBaseManager来决定。
    AIFURLResponseStatusErrorTimeout,
    AIFURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSTimeInterval kAIFNetwotkingTimeoutSeconds = 20.0f;

#endif /* AIFNetworkingConfiguration_h */
