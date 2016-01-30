//
//  AIFURLResponse.m
//  PywSdk
//
//  Created by yunyoufeitian on 16/1/19.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "AIFURLResponse.h"
#import "NSURLRequest+AIFNetworkingMethods.h"
#import "NSObject+AXNetworkingMethods.h"

@interface AIFURLResponse()

@property (nonatomic, assign, readwrite)AIFURLResponseStatus status;
@property (nonatomic, copy, readwrite)NSString *contentString;
@property (nonatomic, copy, readwrite)id content;
@property (nonatomic, copy, readwrite)NSURLRequest *request;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (nonatomic, copy, readwrite)NSData *responseData;
@property (nonatomic, assign, readwrite) BOOL isCache;

@end

@implementation AIFURLResponse

- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData stataus:(AIFURLResponseStatus)status{
    self = [super init];
    if (self) {
        self.contentString = responseString;
        self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        self.status = status;
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        self.isCache = NO;
    }
    return self;
}


- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error{
    self = [super init];
    if (self) {
        self.contentString = [responseString AIF_defaultValue:@""];
        self.status = [self responseStatusWithError:error];
        self.requestId = [requestId integerValue];
        self.request = request;
        self.responseData = responseData;
        self.requestParams = request.requestParams;
        self.isCache = NO;
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        }else{
            self.content = nil;
        }
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data{
    self = [super init];
    if (self) {
        self.contentString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.status = [self responseStatusWithError:nil];
        self.requestId = 0;
        self.request = nil;
        self.responseData = [data copy];
        self.content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.isCache = YES;
    }
    return self;
}

#pragma mark - private method
- (AIFURLResponseStatus)responseStatusWithError:(NSError *)error{
    if (error) {
        AIFURLResponseStatus result = AIFURLResponseStatusErrorNoNetwork;
        if (error.code == NSURLErrorTimedOut) {
            result = AIFURLResponseStatusErrorNoNetwork;
        }
        return result;
    }else{
        return AIFURLResponseStatusSuccess;
    }
}
@end
