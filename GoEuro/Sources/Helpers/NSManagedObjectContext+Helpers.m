//
//  NSManagedObjectContext+Helpers.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "NSManagedObjectContext+Helpers.h"

@implementation NSManagedObjectContext (Helpers)

#pragma mark - Methods

/**
 Save context silently

 @return If save proceed without errors returns true
 */
- (BOOL)save {
    NSError *error = nil;
    [self save:&error];

    if (error) {
        NSLog(@"%@", error);
        return NO;
    }

    return YES;
}

- (RACSignal *)signalForExecuteFetchRequest:(NSFetchRequest *)fetchRequest {
    @weakify(self);

    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self performBlock:^{
            NSError *error = nil;
            NSArray *results = [self executeFetchRequest:fetchRequest error:&error];
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:results];
                [subscriber sendCompleted];
            }
        }];

        return [RACDisposable disposableWithBlock:^{}];
    }];
}

#pragma mark - Class

/**
 Converts object (JSON dictionary) to the object mapped of given class type.

 @param responseObject object that will be conververted
 @param class type to which data will be converted. Must implement JSONSerializable protocol
 @param context Core data context that will be used to manage object configuration
 @return object created from given JSON
 */
+ (nullable id<JSONSerializable>)transformApiResponseFromDictionary:(nonnull id)responseObject toClass:(nonnull Class)class inContext:(nonnull NSManagedObjectContext *)context {
    if (![class conformsToProtocol:@protocol(JSONSerializable)] && ![responseObject isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    return [class createFromJSON:responseObject context:context];
}


/**
 Converts object (Array of JSON dictionaries) to the array of objects mapped to given class type.

 @param responseObject Array of passed class type instances
 @param class type to witch each object will be converted
 @param context core data context that will be used to manage object configuration
 @return array of objects with type passed as parameter
 */
+ (nullable NSArray *)transformApiResponseFromArray:(nonnull id)responseObject toClass:(nonnull Class)class inContext:(nonnull NSManagedObjectContext *)context {
    if (![class conformsToProtocol:@protocol(JSONSerializable)] && ![responseObject isKindOfClass:[NSArray class]]) {
        return nil;
    }

    NSArray *responseArray = (NSArray *)responseObject;
    NSMutableArray *resultArray = [NSMutableArray arrayWithCapacity:responseArray.count];

    for (NSDictionary *elem in responseArray) {
        if ([elem isKindOfClass:[NSDictionary class]]) {
            id<JSONSerializable> object = [[self class] transformApiResponseFromDictionary:elem toClass:class inContext:context];
            if (object) {
                [resultArray addObject:object];
            }
        }
    }

    return resultArray;
}

@end
