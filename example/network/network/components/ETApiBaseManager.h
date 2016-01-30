//
//  ETApiURLManager.h
//  PywSdk
//
//  Created by yunyoufeitian on 16/1/18.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AIFURLResponse.h"


@class  ETApiBaseManager;

static NSString * const kRTAPIBaseManagerRequestID = @"kRTAPIBaseManagerRequestID";

@protocol ETAPIManagerApiCallBackDelegate <NSObject>

/************************************************************************************************************************************************
 *                          ETAPIManagerApiCallBackDelegate（回调函数）
 ************************************************************************************************************************************************/
@required
- (void)managerCallAPIDisSuccess:(ETApiBaseManager *)manager;
- (void)managerCallApiDidFailed:(ETApiBaseManager *)manager;
@end

/************************************************************************************************************************************************
 *                          ETAPIManagerCallbackDataReformer
 ************************************************************************************************************************************************/
/**
 *  利用reformer来返回view直接可用的数据
 */
@protocol ETAPIManagerCallbackDataReformer <NSObject>
@required
- (id)manager:(ETApiBaseManager *)manager reformData:(id)data;
@end




@protocol ETAPIManagerValidator <NSObject>

@required
- (BOOL)manager:(ETApiBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;
- (BOOL)manager:(ETApiBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data;

@end

/*************************************************************************************************/
/*                                ETAPIManagerParamSourceDelegate                                */
/*************************************************************************************************/
@protocol ETAPIManagerParamSourceDelegate <NSObject>
@required
- (NSDictionary *)paramsForApi:(ETApiBaseManager *)manager;
@end

/************************************************************************************************************************************************
 *                         错误状态以及请求类型
 ************************************************************************************************************************************************/
typedef NS_ENUM(NSUInteger, ETManagerErrorType) {
    ETManagerErrorTypeDefault,  // 没有产生过API请求，这个是manager的默认状态
    ETManagerErrorTypeErrorTypeSuccess,  // API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的
    ETManagerErrorTypeErrorTypeNoContent, // API请求成功但返回数据不正确，此时回调数据验证函数返回值为NO
    ETManagerErrorTypeErrorTypeParamsError,  // 参数错误，此时manager不会调用AP之前做的
    ETManagerErrorTypeErrorTypeTimeout, // 请求超时
    ETManagerErrorTypeErrorTypeNoNetWork,  // 网络不通。在调用API之前判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面的状态有区别
};

typedef NS_ENUM(NSUInteger, ETAPIManagerRequestType) {
    ETAPIManagerRequestTypeGet,
    ETAPIManagerRequestTypePost,
    ETAPIManagerRequestTypeRestGet,
    ETAPIManagerRequestTypeRestPost,
};

/*************************************************************************************************/
/*                                        ETAPIManager                                          */
/*************************************************************************************************/
@protocol ETAPIManager <NSObject>

@required
- (NSString *)methodName;
- (NSString *)seriviceType;
- (ETAPIManagerRequestType)requestType;

@optional
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (BOOL)shouldCache;

@end

/*************************************************************************************************/
/*                                    ETAPIManagerInterceptor                                    */
/*************************************************************************************************/
@protocol ETAPIManagerInterceptor <NSObject>

@optional

@end


/*************************************************************************************************/
/*                                       ETApiBaseManager                                        */
/*************************************************************************************************/
@interface ETApiBaseManager : NSObject

@property (nonatomic, weak) id<ETAPIManagerApiCallBackDelegate> delegate;
@property (nonatomic, weak) id<ETAPIManagerParamSourceDelegate> paramSource;
@property (nonatomic, weak) id<ETAPIManagerValidator> validate;
@property (nonatomic, weak) NSObject<ETAPIManager> * child;

@property (nonatomic, copy, readonly)NSString *errorMessage;
@property (nonatomic, readonly) ETManagerErrorType errorType;

@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

- (id)fetchDataWithReformer:(id<ETAPIManagerCallbackDataReformer>)reformer;

// 尽量使用loadData这个方法，这个方法通过param source来获取参数，这使得参数的生成逻辑位于controller中得固定位置
- (NSInteger)loadData;

//拦截器
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params;
- (void)afterCallingAPIWithParams:(NSDictionary *)params;

- (NSDictionary *)reformParams:(NSDictionary *)params;
- (void)cleanData;
- (BOOL)shouldCache;
@end