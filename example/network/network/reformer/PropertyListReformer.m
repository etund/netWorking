 //
//  PropertyListReformer.m
//  PywSdk
//
//  Created by yunyoufeitian on 16/1/21.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "PropertyListReformer.h"
#import "AIFInitManager.h"
#import "AppUtil.h"

@implementation PropertyListReformer

- (NSDictionary *)manager:(ETApiBaseManager *)manager reformData:(id)data{
    NSDictionary *resultData = nil;
    NSData * decodeResponse = [AppUtil decode:data];
    resultData = [NSJSONSerialization JSONObjectWithData:decodeResponse options:NSJSONReadingMutableContainers error:nil];
    return resultData;
}

@end
