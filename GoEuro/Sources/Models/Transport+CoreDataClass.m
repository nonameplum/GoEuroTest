//
//  Transport+CoreDataClass.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "Transport+CoreDataClass.h"
#import "NSEntityDescription+EntityManagement.h"
#import "NSManagedObjectContext+Helpers.h"

NSString *_Nonnull const TransportArrivalTimeKey = @"arrival_time";
NSString *_Nonnull const TransportDepartureTimeKey = @"departure_time";
NSString *_Nonnull const TransportIdKey = @"id";
NSString *_Nonnull const TransportNumberOfStopsKey = @"number_of_stops";
NSString *_Nonnull const TransportPriceInEurosKey = @"price_in_euros";
NSString *_Nonnull const TransportProviderLogoKey = @"provider_logo";

@implementation Transport

#pragma mark - JSON Serializable
+ (instancetype)createFromJSON:(NSDictionary *)jsonDictionary context:(NSManagedObjectContext *)context {
    id idValue = jsonDictionary[TransportIdKey];
    if (!idValue) {
        return nil;
    }

    Transport *transport = [NSEntityDescription insertOrGetExistingEntityForName:NSStringFromClass([self class])
                                                                     entityIdKey:@"idKey"
                                                                   entityIdValue:idValue
                                                                       inContext:context];
    
    transport.arrivalTime = [[self class] dateFromDateString:jsonDictionary[TransportArrivalTimeKey]];
    transport.departureTime = [[self class] dateFromDateString:jsonDictionary[TransportDepartureTimeKey]];
    transport.duration = [[self class] durationBetweenWithDepartureTime:transport.departureTime arrivalTime:transport.arrivalTime];
    transport.idKey = [jsonDictionary[TransportIdKey] intValue];
    transport.numberOfStops = [jsonDictionary[TransportNumberOfStopsKey] intValue];
    transport.priceInEuros = [jsonDictionary[TransportPriceInEurosKey] floatValue];
    transport.providerLogo = [[self class] stringFromValue:jsonDictionary[TransportProviderLogoKey]];

    return transport;
}

#pragma mark Fetch Requests
+ (NSFetchRequest *)fetchRequestWithSortDescriptor:(NSSortDescriptor *)sortDescriptor {
    NSFetchRequest *fetchRequest = [[self class] fetchRequest];
    fetchRequest.sortDescriptors = @[sortDescriptor];
    return fetchRequest;
}

#pragma mark Sort Descriptors
+ (NSSortDescriptor *)departureTimeSortDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:@"departureTime" ascending:YES];
}

+ (NSSortDescriptor*)arrivalTimeSortDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:@"arrivalTime" ascending:YES];
}

+ (NSSortDescriptor *)durationSortDescriptor {
    return [NSSortDescriptor sortDescriptorWithKey:@"duration" ascending:YES];
}

#pragma mark - Helpers
+ (nullable NSString*)stringFromValue:(id)value {
    return [value isKindOfClass:[NSString class]] ? value : [value stringValue];
}

+ (nullable NSDate *)dateFromDateString:(NSString *)dateString {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"HH:mm";
    return [format dateFromString:dateString];
}

+ (NSInteger)durationBetweenWithDepartureTime:(NSDate *)departureTime arrivalTime:(NSDate *)arrivalTime  {
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitMinute
                                                                   fromDate:departureTime
                                                                     toDate:arrivalTime
                                                                    options: 0];
    return components.minute;
}

@end
