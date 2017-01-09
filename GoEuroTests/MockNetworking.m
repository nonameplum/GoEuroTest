//
//  MockNetworking.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2017 Łukasz Śliwiński. All rights reserved.
//

#import "MockNetworking.h"
#import "GoEuroTestHelpers.h"

@implementation MockNetworking

- (instancetype)init
{
    self = [super init];
    if (self) {
        _networkReachable = YES;
        _testDataJsonFileName = @"testBusData.json";
    }
    return self;
}

- (RACSignal *)signalForGET:(NSString *)url parameters:(id)parameters {
    return [RACSignal return:[GoEuroTestHelpers dictionaryWithContentsOfJSONString:self.testDataJsonFileName]];
}

- (RACSignal *)signalForGETImage:(NSString *)url {
    return [RACSignal empty];
}

- (BOOL)isNetworkReachable {
    return self.networkReachable;
}

@end
