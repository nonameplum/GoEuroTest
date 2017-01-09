//
//  ProviderLogoDAO.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "ProviderLogoDAO.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ProviderLogoDAO

NSString *_Nonnull const ProviderLogoDAOImageSize = @"63";
NSString *_Nonnull const ProviderLogoDAOCacheNamespace = @"GoEuroProviderLogoCache";

#pragma mark - Methods
- (RACSignal *)getProviderLogoFromURL:(NSString *)url {
    NSString *destinationURL = [url stringByReplacingOccurrencesOfString:@"{size}" withString:ProviderLogoDAOImageSize];

    return [[[self getProviderLogoFromCacheWithUrl:destinationURL]
     flattenMap:^RACStream *(UIImage * _Nullable image) {
         if (!image) {
             return [[self.networkApi signalForGETImage:destinationURL] doNext:^(UIImage *fetchedImage) {
                 SDImageCache *imageCache = [[SDImageCache alloc] initWithNamespace:ProviderLogoDAOCacheNamespace];
                 [imageCache storeImage:fetchedImage forKey:destinationURL toDisk:YES];
             }];
         }
         return [RACSignal return:image];
    }]
    deliverOnMainThread];
}

- (RACSignal *)getProviderLogoFromCacheWithUrl:(nonnull NSString *)url {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        SDImageCache *imageCache = [[SDImageCache alloc] initWithNamespace:ProviderLogoDAOCacheNamespace];
        NSOperation *imageQueryOperation = [imageCache queryDiskCacheForKey:url done:^(UIImage *image, SDImageCacheType cacheType) {
            [subscriber sendNext:image];
            [subscriber sendCompleted];
        }];

        return [RACDisposable disposableWithBlock:^{
            [imageQueryOperation cancel];
        }];
    }];
}

@end
