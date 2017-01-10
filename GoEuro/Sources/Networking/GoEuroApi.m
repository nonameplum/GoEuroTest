//
//  GoEuroApi.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "GoEuroApi.h"
#import "SettingsManager.h"
#import "CoreDataManager.h"
#import <AFNetworking/AFNetworking.h>

NSString *_Nonnull const GoEuroApiAFNetworkingReactiveCocoaErrorInfoKey = @"GoEuroApiAFNetworkingReactiveCocoaErrorInfoKey";

@interface GoEuroApi ()

@property (strong, nonatomic, nonnull) AFHTTPSessionManager *manager;
@property (strong, nonatomic, nonnull) NSURLSessionConfiguration *configuration;

@end

@implementation GoEuroApi

#pragma mark - Initialization
- (nonnull instancetype)init {
    self = [self initWithBaseURL:[SettingsManager baseApiURL]];
    return self;
}

- (nonnull instancetype)initWithBaseURL:(nonnull NSURL *)baseURL {
    self = [super init];
    if (self) {
        _configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL sessionConfiguration:_configuration];
        _manager.requestSerializer.timeoutInterval = 10;
        [_manager.reachabilityManager startMonitoring];
    }

    return self;
}

#pragma mark - NetworkingApi
- (nonnull RACSignal *)signalForGET:(nonnull NSString *)url parameters:(nullable id)parameters {
    @weakify(self);
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);

        NSURLSessionDataTask* task = [self.manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
            userInfo[GoEuroApiAFNetworkingReactiveCocoaErrorInfoKey] = task;
            NSError *errorWithTask = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
            [subscriber sendError:errorWithTask];
        }];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (nonnull RACSignal *)signalForGETImage:(nonnull NSString *)url {
    @weakify(self);

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);

        AFHTTPSessionManager *manager = [self.manager copy];
        manager.responseSerializer = [AFImageResponseSerializer serializer];

        NSURLSessionDataTask* task = [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
            userInfo[GoEuroApiAFNetworkingReactiveCocoaErrorInfoKey] = task;
            NSError *errorWithTask = [NSError errorWithDomain:error.domain code:error.code userInfo:userInfo];
            [subscriber sendError:errorWithTask];
        }];

        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (BOOL)isNetworkReachable {
    if (self.manager.reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    }

    return self.manager.reachabilityManager.isReachable;
}

#pragma mark - Class
+ (GoEuroApi *)sharedInstance {
    static dispatch_once_t once;
    static GoEuroApi *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end
