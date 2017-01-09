//
//  MockNetworking.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2017 Łukasz Śliwiński. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoEuroApi.h"

@interface MockNetworking: NSObject <NetworkingApi>

@property (assign, nonatomic) BOOL networkReachable;
@property (strong, nonatomic, nonnull) NSString *testDataJsonFileName;

@end
