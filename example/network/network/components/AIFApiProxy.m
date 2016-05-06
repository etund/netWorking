//
//  AIFApiProxy.m
//  PywSdk
//
//  Created by liangyidong on 16/1/20.
//  Copyright © 2016年 zero. All rights reserved.
//
#import "AIFApiProxy.h"
#import "AFNetworking.h"
#import "AIFRequestGenerator.h"

@interface AIFApiProxy()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation AIFApiProxy

#pragma mark - getters and setters
- (NSMutableDictionary *)dispatchTable{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPSessionManager *)sessionManager{
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _sessionManager;
}

#pragma mark - life cycle
signleton_m(ApiProxy)

#pragma mark - public methods
- (NSInteger)callGETWithParams:(NSDictionary *)params seriviceIndentifier:(NSString *)seriviceIdentifier methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail{
    return 0;
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params seriviceIndentifier:(NSString *)seriviceIdentifier methodName:(NSString *)methodName success:(AXCallback)success fail:(AXCallback)fail{
    NSURLRequest *request = [[AIFRequestGenerator sharedRequestGenerator] generatePOSTRequestWithServiceIdentifier:seriviceIdentifier requestParams:params methodName:methodName];
    NSNumber *requestId = [self callApiWithRequest:request success:success fail:fail];
    return [requestId integerValue];
}

#pragma mark - private methods 


/**
 * 这个函数存在的意义在于，如果将来要把AFNetwoking换掉，只要修改这个函数的实现即可
 */
- (NSNumber *)callApiWithRequest:(NSMutableURLRequest *)request success:(AXCallback)success fail:(AXCallback)fail{
    NSNumber *requestId = [self generateRequestId];
    
    NSURLSessionDataTask *dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            AIFURLResponse *response_0 = [[AIFURLResponse alloc] initWithResponseString:response.description
                                                                            requestId:requestId
                                                                                request:[NSURLRequest requestWithURL:response.URL]
                                                                         responseData:responseObject
                                                                                error:error];
            PLog(@"请求有误==========================%@", error);
            fail ? fail(response_0) : nil;
        }else{
            AIFURLResponse *response_0 = [[AIFURLResponse alloc] initWithResponseString:response.description
                                                                            requestId:requestId
                                                                              request:[NSURLRequest requestWithURL:response.URL]
                                                                         responseData:responseObject
                                                                              stataus:AIFURLResponseStatusSuccess];
            success ? success(response_0) : nil;
        }
    }];
    [dataTask resume];
    self.dispatchTable[requestId] = dataTask;
    return requestId;
}

- (NSNumber *)generateRequestId{
    if (_recordedRequestId == nil) {
        _recordedRequestId = @(1);
    }else{
        if ([_recordedRequestId integerValue] == NSIntegerMax) {
            _recordedRequestId = @(1);
        }else{
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

- (void)cancelRequestWithRequestId:(NSNumber *)requestID{
    NSURLSessionDataTask *dataTask = self.dispatchTable[requestID];
    [dataTask cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIdList:(NSArray *)requestIDList{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestId:requestId];
    }
}

@end
