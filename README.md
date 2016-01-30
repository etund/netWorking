# NetWorking

#### 简介

- 这是一个网络层框架，是参考这位博主[这里](http://casatwy.com/iosying-yong-jia-gou-tan-wang-luo-ceng-she-ji-fang-an.html)的博文写的，但是由于我个人对自己比较严格，我在一个星期里面把这个架构看懂并且自己亲手写出来并且已经用到自己的项目了，越看越喜欢，感谢博主。
  
- 这里是鱼，直接教大家怎么用，直接用起来。
  
  - 新建一个manager
    
    ``` objective-c
    //.h
    #import "ETApiBaseManager.h"
    
    @interface AIFInitManager : ETApiBaseManager <ETAPIManager, ETAPIManagerParamSourceDelegate, ETAPIManagerValidator>
    
    @end
      
    //.m
      #import "AIFInitManager.h"
    #import "PropertyListReformer.h"
    
    
    @implementation AIFInitManager
    
    - (instancetype)init
    {
        self = [super init];
        if (self) {
            self.child = self; // 用于返回url, 请求服务类型
            self.paramSource = self; // 用于返回请求参数
            self.validate = self;	// 用于验证请求参数
        }
        return self;
    }
    
    
    #pragma mark - ETAPIManager
    - (NSString *)methodName{
        return URL_INIT;
    }
    
    - (ETAPIManagerRequestType)requestType{
        return ETAPIManagerRequestTypePost;
    }
    
    
    - (NSString *)seriviceType{
        return @"kAIFServiceCeShi";
    }
    
    
    #pragma mark - ETAPIManagerParamSourceDelegate
    - (NSDictionary *)paramsForApi:(ETApiBaseManager *)manager{
        NSString *tid = [PywPlatformMain sharedPlatformMain].uuid;
        return @{
                 SDK_GAMEKEY:@"a913777e",
                 SDK_TID:tid
                 };
    }
    
    
    
    #pragma mark - ETAPIManagerValidator
    - (BOOL)manager:(ETApiBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data{
        return YES;
    }
    
    - (BOOL)manager:(ETApiBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data{
        return YES;
    }
    @end
    ```
    
    - 在请求者里面遵循协议\<ETAPIManagerApiCallBackDelegate\>协议用于参数回调
      
      ``` objective-c
      @interface PywSdk() <ETAPIManagerApiCallBackDelegate>
        
      - (void)viewDidAppearance{
        	AIFInitManager *manager = [[AIFInitManager alloc] init];
          manager.delegate = self;
          [manager loadData]; // 这里开始请求加载数据
      } 
      
      #pragma mark - ETAPIManagerApiCallBackDelegate
      - (void)managerCallAPIDisSuccess:(ETApiBaseManager *)manager{// 请求成功
        
      }
      - (void)managerCallApiDidFailed:(ETApiBaseManager *)manager{ // 请求失败
        
      }
      ```
      
    - 这里还有对返回参数的处理
      
      - 新建一个reformer并且集成协议(一种返回类型新建一个reformer，例如有返回类型是NSArray和NSDictionary的要建两个reformer)
        
        ``` objective-c
        @interface PropertyListReformer : NSObject <ETAPIManagerCallbackDataReformer>
        ```
        
        - 在里面你可以做解密的操作(我们公司需要解密)
          
          ``` objective-c
          //PropertyListReformer.m
            
          @implementation PropertyListReformer
          
          - (NSDictionary *)manager:(ETApiBaseManager *)manager reformData:(id)data{
              NSDictionary *resultData = nil;
              NSData * decodeResponse = [AppUtil decode:data];
              resultData = [NSJSONSerialization JSONObjectWithData:decodeResponse options:NSJSONReadingMutableContainers error:nil];
              return resultData;
          }
          
          @end
          ```
          
          ​


- 简单来说，一个执行者(请求发起者)，一个manager，一个refomer就可以用这个框架了。至于想要渔的，看博主的博客吧