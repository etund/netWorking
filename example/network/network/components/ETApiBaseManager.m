//
//  ETApiURLManager.m
//  PywSdk
//
//  Created by yunyoufeitian on 16/1/18.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "ETApiBaseManager.h"
#import "AIFApiProxy.h"
#import "ApiClient.h"

#define AXCallAPI(REQUEST_METHOD, REQUEST_ID)                                                       \
{                                                                                       \
REQUEST_ID = [[AIFApiProxy sharedApiProxy] callPOSTWithParams:apiParams seriviceIndentifier:self.child.seriviceType methodName:self.child.methodName success:^(AIFURLResponse *response){ \
[self successedOnCallingAPI:response];                                          \
} fail:^(AIFURLResponse *response) {                                                \
[self failedOnCallingAPI:response withErrorType:ETManagerErrorTypeDefault];  \
}];                                                                                 \
[self.requestIdList addObject:@(REQUEST_ID)];                                          \
}

@interface ETApiBaseManager()
@property (nonatomic, copy, readwrite) id fetchedRawData;
@property (nonatomic, copy, readwrite) NSString *errorMessage;
@property (nonatomic, readwrite) ETManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;

@end

@implementation ETApiBaseManager

#pragma mark - getters and setters
// 请求列表
- (NSMutableArray *)requestList{
    
    if (!_requestIdList) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable{
    BOOL isReachability = [ApiClient sharedApiClient].isReachable;
    if (!isReachability) {
        self.errorType = ETManagerErrorTypeErrorTypeNoNetWork;
    }
    return isReachability;
}

- (BOOL)isLoading{
    return [self.requestList count] > 0;
}

#pragma mark - life cycle
- (instancetype)init{
    self = [super init];
    if (self) {
        _delegate = nil;
        _paramSource = nil;
        _fetchedRawData = nil;
        _errorMessage = nil;
        _errorType = ETManagerErrorTypeDefault;
        if ([self conformsToProtocol:@protocol(ETAPIManager)]) {
            self.child = (id<ETAPIManager>) self;
        }
    }
    return self;
}

#pragma mark - public methods
- (id)fetchDataWithReformer:(id<ETAPIManagerCallbackDataReformer>)reformer{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    }else{
        resultData = [self.fetchedRawData mutableCopy];
    }
    return resultData;
}


#pragma mark - calling api
- (NSInteger)loadData{
    NSDictionary *params = [self.paramSource paramsForApi:self];
    params = [self unifiedParames:params];
    NSInteger requestId = [self loadDataWithParams:params];
    return requestId;
}

- (NSInteger)loadDataWithParams:(NSDictionary *)params{
    NSInteger requestId = 0;
    NSDictionary *apiParams = [self reformParams:params];
    if ([self shouldCallAPIWithParams:apiParams]) {
        if ([self.validate manager:self isCorrectWithCallBackData:apiParams]) {
//            if ([self shouldCache] && [self hasCacheWithParams:apiParams]) {
//                return 0;
//            }
            if ([self isReachable]) {
                switch (self.child.requestType) {
                    case ETAPIManagerRequestTypeGet:
                        AXCallAPI(GET, requestId);
                        break;
                    case ETAPIManagerRequestTypePost:
                        AXCallAPI(POST, requestId);
                        break;
                    case ETAPIManagerRequestTypeRestGet:
                        AXCallAPI(RestfulGET, requestId);
                        break;
                    case ETAPIManagerRequestTypeRestPost:
                        AXCallAPI(RestfulPOST, requestId);
                        break;
                    default:
                        break;
                }
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kRTAPIBaseManagerRequestID] = @(requestId);
                [self afterCallingAPIWithParams:params];
                return requestId;
            }else{
                [self failedOnCallingAPI:nil withErrorType:ETManagerErrorTypeErrorTypeNoNetWork];
                return requestId;
            }
        }else{
            [self failedOnCallingAPI:nil withErrorType:ETManagerErrorTypeErrorTypeParamsError];
        }
    }
    return requestId;
}

#pragma mark - api callbacks
- (void)apiCallBack:(AIFURLResponse *)response{
    if (response.status == AIFURLResponseStatusSuccess) {
        [self successedOnCallingAPI:response];
    }else{
        [self failedOnCallingAPI:response withErrorType:ETManagerErrorTypeErrorTypeTimeout];
    }
}

- (void)successedOnCallingAPI:(AIFURLResponse *)response{
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    }else{
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestId];
    if ([self.validate manager:self isCorrectWithCallBackData:response.content]) {
        if ([self shouldCache] && !response.isCache) {
        }
        [self.delegate managerCallAPIDisSuccess:self];
    }
}

- (void)failedOnCallingAPI:(AIFURLResponse *)response withErrorType:(ETManagerErrorType)errorType
{
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestId];
    [self.delegate managerCallApiDidFailed:self];
}

#pragma mark - method for interceptor
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params{
    return YES;
}

- (void)afterCallingAPIWithParams:(NSDictionary *)params{
    
}

#pragma mark - method for child
- (void)cleanData{
    IMP childIMP = [self.child methodForSelector:@selector(cleanData)];
    IMP selfIMP = [self methodForSelector:@selector(cleanData)];
    
    if (childIMP == selfIMP) {
        self.fetchedRawData = nil;
        self.errorMessage = nil;
        self.errorType = ETManagerErrorTypeDefault;
    }else{
        if ([self.child respondsToSelector:@selector(cleanData)]) {
            [self.child cleanData];
        }
    }
}

- (NSDictionary *)reformParams:(NSDictionary *)params{
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    
    if (childIMP == selfIMP) {
        return params;
    }else{
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return  result;
        }else{
            return params;
        }
    }
}

- (BOOL)shouldCache{
    return YES;
}

#pragma mark - private methods
- (void)removeRequestIdWithRequestID:(NSInteger)requestId{
    NSNumber *requestIdToRemove = nil;
    for (NSNumber *storeRequestId in self.requestList) {
        if ([storeRequestId integerValue] == requestId) {
            requestIdToRemove = storeRequestId;
        }
    }
    if (requestIdToRemove) {
        [self.requestList removeObject:requestIdToRemove];
    }
}

- (BOOL)hasCacheWithParams:(NSDictionary *)params{
    NSString *serviceIdentifier = self.child.seriviceType;
    NSString *methodName = self.child.methodName;
    return YES;
}

- (NSDictionary *)unifiedParames:(NSDictionary *)parames{
    __block NSMutableDictionary * muParames = [NSMutableDictionary dictionaryWithDictionary:parames];
    //    bundleID
    NSString * identifier = [[NSBundle mainBundle] bundleIdentifier];
    //    ip地址
    NSString * ipAdress = [PywPlatformMain sharedPlatformMain].ipAdress;
    //    app版本号
    NSString * verID = [PywPlatformMain sharedPlatformMain].verID;
    //    设备名
    NSString * devName = [PywPlatformMain sharedPlatformMain].devName;
    //    系统版本
    NSString * sysVersion = [PywPlatformMain sharedPlatformMain].sysVersion;
    
    
    
    muParames[UNIFYPARAMES_IDENTIFIER] = identifier;
    muParames[UNIFYPARAMES_IPADRESS] = ipAdress;
    muParames[UNIFYPARAMES_VER] = verID;//verID;
    muParames[UNIFYPARAMES_SDK_TYPE] = @"2";
    muParames[UNIFYPARAMES_DEVNAME] = devName;
    muParames[UNIFYPARAMES_SYSVERSION] = sysVersion;
    muParames[UNIFYPARAMES_OS] = @"IOS";
    muParames[UNIFYPARAMES_IMIE] = @"";
    return [muParames copy];
}

@end
