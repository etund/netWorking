//
//  NSURLRequest+AIFNetworkingMethods.m
//  PywSdk
//
//  Created by yunyoufeitian on 16/1/20.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "NSURLRequest+AIFNetworkingMethods.h"
#import <objc/runtime.h>

@implementation NSURLRequest (AIFNetworkingMethods)

static void *AIFNetworkingRequestParams;

- (void)setRequestParams:(NSDictionary *)requestParams{
    objc_setAssociatedObject(self, &AIFNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDictionary *)requestParams{
    return objc_getAssociatedObject(self, &AIFNetworkingRequestParams);
}

@end
