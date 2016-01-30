//
//  AIFURLResponse.h
//  PywSdk
//
//  Created by yunyoufeitian on 16/1/19.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIFNetworkingConfiguration.h"

@interface AIFURLResponse : NSObject

@property (nonatomic, assign, readonly) AIFURLResponseStatus status;
@property (nonatomic, copy, readonly)NSString *contentString;
@property (nonatomic, copy, readonly) id content;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData * responseData;
@property (nonatomic, copy) NSDictionary *requestParams;
@property (nonatomic, assign, readonly) BOOL isCache;

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData stataus:(AIFURLResponseStatus)status;

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error;

// 使用initWithData的response，他的isCache是YES，上面的函数生成的response的isCache是NO
- (instancetype)initWithData:(NSData *)data;

@end
