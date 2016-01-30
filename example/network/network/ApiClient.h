//
//  ApiClient.h
//  PywSdk
//
//  Created by yunyoufeitian on 15/12/24.
//  Copyright © 2015年 zero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"



@interface ApiClient : NSObject



signleton_h(ApiClient)

@property (nonatomic, readonly) BOOL isReachable;

@end
