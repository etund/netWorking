//
//  AIFApiProxy.m
//  PywSdk
//
//  Created by yunyoufeitian on 16/1/20.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "AIFApiProxy.h"
#import "AFNetworking.h"
#import "AIFRequestGenerator.h"


@interface AIFApiProxy()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;

@property (nonatomic, strong) AFHTTPRequestOperationManager *operationManager;

@end

@implementation AIFApiProxy

#pragma mark - getters and setters
- (NSMutableDictionary *)dispatchTable{
    if (_dispatchTable == nil) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

- (AFHTTPRequestOperationManager *)operationManager{
    if (_operationManager == nil) {
        _operationManager = [[AFHTTPRequestOperationManager alloc] init];
        _operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
         NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
        _operationManager.requestSerializer.stringEncoding = enc;
    }
    return _operationManager;
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
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(AXCallback)success fail:(AXCallback)fail{
    NSNumber *requestId = [self generateRequestId];
    AFHTTPRequestOperation *httpRequestOpration = [self.operationManager HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        AIFURLResponse *response = [[AIFURLResponse alloc] initWithResponseString:operation.responseString
                                                                        requestId:requestId
                                                                          request:operation.request
                                                                     responseData:operation.responseData
                                                                          stataus:AIFURLResponseStatusSuccess];
        success ? success(response) : nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        AFHTTPRequestOperation *storedOperation = self.dispatchTable[requestId];
        AIFURLResponse *response = [[AIFURLResponse alloc] initWithResponseString:operation.responseString
                                                                        requestId:requestId
                                                                          request:operation.request
                                                                     responseData:operation.responseData
                                                                                error:error];
        fail ? fail(response) : nil;
    }];
    self.dispatchTable[requestId] = httpRequestOpration;
    [[self.operationManager operationQueue] addOperation:httpRequestOpration];
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
@end
