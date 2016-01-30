//
//  ApiClient.m
//  PywSdk
//
//  Created by yunyoufeitian on 15/12/24.
//  Copyright © 2015年 zero. All rights reserved.
//

#import "ApiClient.h"
#import "ApiClientConst.h"
#import "AFNetworking.h"



@implementation ApiClient

signleton_m(ApiClient)

- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}
@end