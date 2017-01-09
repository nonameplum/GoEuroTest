//
//  NSManagedObjectContext+Helpers.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "JSONSerializable.h"

@interface NSManagedObjectContext (Helpers)

#pragma mark - Methods
- (BOOL)save;

- (nonnull RACSignal *)signalForExecuteFetchRequest:(nonnull NSFetchRequest *)fetchRequest;

#pragma mark - Class
+ (nullable id<JSONSerializable>)transformApiResponseFromDictionary:(nonnull id)responseObject toClass:(nonnull Class)class inContext:(nonnull NSManagedObjectContext *)context;
+ (nullable NSArray *)transformApiResponseFromArray:(nonnull id)responseObject toClass:(nonnull Class)class inContext:(nonnull NSManagedObjectContext *)context;

@end
