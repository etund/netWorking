//
//  AIFService.m
//  PywSdk
//
//  Created by yunyoufeitian on 16/1/20.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "AIFService.h"

@implementation AIFService

- (instancetype)init{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(AIFServiceProtocal)]) {
            self.child = (id<AIFServiceProtocal>)self;
        }
    }
    return self;
}

#pragma mark - getters and setters
- (NSString *)privateKey{
    return  self.child.isOnline ? self.child.onlinePrivateKey : self.child.offlinePrivateKey;
    
}

- (NSString *)publicKey{
    return self.child.isOnline ? self.child.onlinePublicKey : self.child.offlinePublicKey;
}

- (NSString *)apiBaseUrl{
    return self.child.isOnline ? self.child.onLineApiBaseUrl : self.child.offlineApiBaseUrl;
}

- (NSString *)apiVersion{
    return self.child.isOnline ? self.child.onlineApiVersion : self.child.offlineApiVersion;
}

@end
