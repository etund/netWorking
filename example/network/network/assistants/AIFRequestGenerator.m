//
//  AIFRequestGenerator.m
//  PywSdk
//
//  Created by liangyidong on 16/1/20.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "AIFRequestGenerator.h"
#import "AFNetworking.h"
#import "AIFService.h"
#import "ApiClient.h"
#import "AIFServiceFactory.h"
#import "NSURLRequest+AIFNetworkingMethods.h"
#import "AppUtil.h"

@interface AIFRequestGenerator()

@property (nonatomic, strong)AFHTTPRequestSerializer<AFURLRequestSerialization> *httpRequestSerializer;

@end

@implementation AIFRequestGenerator

#pragma mark - getters and setters
- (AFHTTPRequestSerializer<AFURLRequestSerialization> *)httpRequestSerializer{
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
        _httpRequestSerializer.stringEncoding = enc;
    }
    return _httpRequestSerializer;
}

#pragma mark - public methods 
signleton_m(RequestGenerator)

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier
                                             requestParams:(NSDictionary *)requestParams
                                                methodName:(NSString *)methodName{
    AIFService *service = [[AIFServiceFactory sharedServiceFactory] serviceWithIdentifier:serviceIdentifier];
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",service.apiBaseUrl, methodName];
    
//    参数加密
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
    NSMutableArray * mArray = [[NSMutableArray alloc] init];
    [mArray addObject:requestParams];
    NSData * tmpData = [NSJSONSerialization dataWithJSONObject:mArray options:0 error:nil];
    NSData *testData = [AppUtil encode:tmpData];
    NSString * paramData = [[ NSString alloc] initWithData:testData encoding:enc];
    //    _manager.
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"param"] = paramData;
    NSMutableURLRequest *request = [self.httpRequestSerializer multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:params constructingBodyWithBlock:nil error:nil];
    return request;
}

@end
