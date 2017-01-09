//
//  NSEntityDescription+EntityManagement.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSEntityDescription (EntityManagement)

#pragma mark - Class
+ (nonnull __kindof NSManagedObject *)insertOrGetExistingEntityForName:(nonnull NSString *)entityName
                                                           entityIdKey:(nonnull NSString *)key
                                                         entityIdValue:(nonnull id)keyValue
                                                             inContext:(nonnull NSManagedObjectContext *)context;

+ (nullable __kindof NSManagedObject *)getExistingEntityForName:(nonnull NSString *)entityName
                                                    entityIdKey:(nonnull NSString *)key
                                                  entityIdValue:(nonnull id)keyValue
                                                      inContext:(nonnull NSManagedObjectContext *)context;

@end
