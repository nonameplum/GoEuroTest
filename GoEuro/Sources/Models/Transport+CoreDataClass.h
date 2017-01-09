//
//  Transport+CoreDataClass.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "JSONSerializable.h"
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Transport : NSManagedObject <JSONSerializable>

#pragma mark - Class
+ (instancetype)createFromJSON:(NSDictionary *)jsonDictionary context:(NSManagedObjectContext *)context;

#pragma mark Fetch Requests
+ (NSFetchRequest *)fetchRequestWithSortDescriptor:(NSSortDescriptor *)sortDescriptor;

#pragma mark Sort Descriptors
+ (NSSortDescriptor *)departureTimeSortDescriptor;
+ (NSSortDescriptor*)arrivalTimeSortDescriptor;
+ (NSSortDescriptor *)durationSortDescriptor;

@end

NS_ASSUME_NONNULL_END

#import "Transport+CoreDataProperties.h"
