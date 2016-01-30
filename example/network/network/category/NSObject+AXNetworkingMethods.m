//
//  NSObject+AXNetworkingMethods.m
//  PywSdk
//
//  Created by yunyoufeitian on 16/1/20.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "NSObject+AXNetworkingMethods.h"

@implementation NSObject (AXNetworkingMethods)

- (id)AIF_defaultValue:(id)defaultData{
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    if ([self AIF_isEmptyObject]) {
        return defaultData;
    }
    return self;
}

- (BOOL)AIF_isEmptyObject{
    if ([self isEqual:[NSNull class]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end
