//
//  BaseDAO.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "GoEuroApi.h"
#import <Foundation/Foundation.h>

@interface BaseDAO : NSObject

#pragma mark - Properties
@property (strong, nonatomic, nonnull) NetworkApi *networkApi;
@property (strong, nonatomic, nonnull) NSManagedObjectContext *context;

#pragma mark - Initialization
- (nullable instancetype)initWithNetworking:(nonnull NetworkApi *)networking withContext:(nonnull NSManagedObjectContext *)context;

@end
