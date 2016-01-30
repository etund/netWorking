//
//  AIFServiceFactory.m
//  PywSdk
//
//  Created by yunyoufeitian on 16/1/20.
//  Copyright © 2016年 zero. All rights reserved.
//

#import "AIFServiceFactory.h"
#import "AIFServiceCeShi.h"

NSString * const kAIFServiceCeSfi = @"kAIFServiceCeShi";

@interface AIFServiceFactory()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation AIFServiceFactory

#pragma mark - getters and settters
- (NSMutableDictionary *)serviceStorage{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

#pragma mark - life cycle
signleton_m(ServiceFactory)

#pragma mark - public methods
- (AIFService<AIFServiceProtocal> *)serviceWithIdentifier:(NSString *)identifier{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private methods 
- (AIFService<AIFServiceProtocal> *)newServiceWithIdentifier:(NSString *)identifier{
    if ([identifier isEqualToString:kAIFServiceCeSfi]) {
        return [[AIFServiceCeShi alloc] init];
    }
    return nil;
}

@end
