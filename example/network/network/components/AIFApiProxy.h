//
//  AIFApiProxy.h
//  PywSdk
//
//  Created by yunyoufeitian on 16/1/20.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "AIFURLResponse.h"

typedef void(^AXCallback)(AIFURLResponse *response);

@interface AIFApiProxy : NSObject

signleton_h(ApiProxy)

- (NSInteger)callGETWithParams:(NSDictionary *)params seriviceIndentifier:(NSString *)seriviceIdentifier methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail;
- (NSInteger)callPOSTWithParams:(NSDictionary *)params seriviceIndentifier:(NSString *)seriviceIdentifier methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail;

- (NSInteger)callRestfulGETWithParams:(NSDictionary *)params seriviceIndentifier:(NSString *)seriviceIdentifier methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail;
- (NSInteger)callRestfulPOSTWithParams:(NSDictionary *)params seriviceIndentifier:(NSString *)seriviceIdentifier methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail;

- (void)cancelRequestWithRequestId:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIdList:(NSArray *)requestIdList;

@end
