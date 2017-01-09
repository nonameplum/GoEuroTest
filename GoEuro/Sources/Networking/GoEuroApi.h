//
//  GoEuroApi.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "JSONSerializable.h"

@protocol NetworkingApi <NSObject>

- (nonnull RACSignal *)signalForGET:(nonnull NSString *)url parameters:(nullable id)parameters;
- (nonnull RACSignal *)signalForGETImage:(nonnull NSString *)url;
- (BOOL)isNetworkReachable;

@end

typedef NSObject<NetworkingApi> NetworkApi;

@interface GoEuroApi : NSObject <NetworkingApi>

#pragma mark - Initialization
- (nonnull instancetype)initWithBaseURL:(nonnull NSURL *)baseURL;

#pragma mark - Methods
- (nonnull RACSignal *)signalForGET:(nonnull NSString *)url parameters:(nullable id)parameters;
- (nonnull RACSignal *)signalForGETImage:(nonnull NSString *)url;
- (BOOL)isNetworkReachable;

#pragma mark - Class
+ (nonnull GoEuroApi *)sharedInstance;

@end
