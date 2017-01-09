//
//  BaseDAO.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "BaseDAO.h"
#import "CoreDataManager.h"

@implementation BaseDAO

#pragma mark - Initialization
- (nullable instancetype)initWithNetworking:(nonnull NetworkApi *)networking withContext:(nonnull NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        _networkApi = networking;
        _context = context;
    }
    return self;
}

- (instancetype)init {
    self = [self initWithNetworking:[GoEuroApi sharedInstance] withContext:[[CoreDataManager sharedInstance] createPrivateManagedObjectContext]];
    return self;
}

@end
