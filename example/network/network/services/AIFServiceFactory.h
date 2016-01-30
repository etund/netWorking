//
//  AIFServiceFactory.h
//  PywSdk
//
//  Created by yunyoufeitian on 16/1/20.
//  Copyright © 2016年 zero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "AIFService.h"

@interface AIFServiceFactory : NSObject

signleton_h(ServiceFactory)
- (AIFService<AIFServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier;
@end
