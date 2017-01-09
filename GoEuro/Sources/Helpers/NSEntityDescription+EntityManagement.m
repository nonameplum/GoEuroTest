//
//  NSEntityDescription+EntityManagement.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "NSEntityDescription+EntityManagement.h"

@implementation NSEntityDescription (EntityManagement)

#pragma mark - Class
+ (nonnull __kindof NSManagedObject *)insertOrGetExistingEntityForName:(nonnull NSString *)entityName
                                                  entityIdKey:(nonnull NSString *)key
                                                entityIdValue:(nonnull id)keyValue
                                                   inContext:(nonnull NSManagedObjectContext *)context {
    __kindof NSManagedObject *existingObject = [self getExistingEntityForName:entityName entityIdKey:key entityIdValue:keyValue inContext:context];

    if (!!existingObject) {
        return existingObject;
    } else {
        __kindof NSManagedObject *newObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        [newObject setValue:keyValue forKey:key];
        return newObject;
    }
}

+ (nullable __kindof NSManagedObject *)getExistingEntityForName:(nonnull NSString *)entityName
                                          entityIdKey:(nonnull NSString *)key
                                        entityIdValue:(nonnull id)keyValue
                                            inContext:(nonnull NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", key, keyValue];

    NSError *error = nil;
    __kindof NSManagedObject *result = [[context executeFetchRequest:fetchRequest error:&error] lastObject];
    if (!!error) {
        NSLog(@"Cannot get existing object for entity %@, %@", entityName, error);
        return nil;
    }

    return result;
}

@end
