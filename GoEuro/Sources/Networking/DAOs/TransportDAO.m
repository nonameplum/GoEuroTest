//
//  TransportDAO.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "TransportDAO.h"
// Models
#import "Flight+CoreDataClass.h"
#import "Bus+CoreDataClass.h"
#import "Train+CoreDataClass.h"
// Others
#import "NSManagedObjectContext+Helpers.h"

NSString *_Nonnull const GoEuroApiFlightsEndpoint = @"bins/w60i";
NSString *_Nonnull const GoEuroApiTrainsEndpoint = @"bins/3zmcy";
NSString *_Nonnull const GoEuroApiBusesEndpoint = @"bins/37yzm";

@interface TransportDAO ()

@property (strong, nonatomic, nonnull) CoreDataScheduler *coreDataScheduler;

@end

@implementation TransportDAO

#pragma mark - Initialization
- (nonnull instancetype)initWithTransportType:(TransportType)transportType {
    self = [super init];
    if (self) {
        _transportType = transportType;
        _coreDataScheduler = [[CoreDataScheduler alloc] initWithContext:self.context];
    }
    return self;
}

- (nonnull instancetype)initWithTransportType:(TransportType)transportType networking:(nonnull NetworkApi *)networking withContext:(nonnull NSManagedObjectContext *)context {
    self = [self initWithNetworking:networking withContext:context];
    if (self) {
        _transportType = transportType;
        _coreDataScheduler = [[CoreDataScheduler alloc] initWithContext:self.context];
    }
    return self;
}

#pragma mark - Methods
- (nonnull RACSignal *)fetchTransportsSortedBy:(TransportSortType)transportSortType {
    NSString *url = [self getUrl];
    Class class = [self getClass];

    NSAssert(!!url && !!class, @"Probably wrong transport type is configured");

    RACSignal *cachedDataSignal = [self fetchCachedTransportsSortedBy:transportSortType];

    if (![self.networkApi isNetworkReachable]) {
        return cachedDataSignal;
    } else {
        @weakify(self);
        RACSignal *networkDataSignal = [[[[[[[self.networkApi signalForGET:url parameters:nil] deliverOn:self.coreDataScheduler]
                                            map:^id(id response) {
                                                @strongify(self);
                                                return [NSManagedObjectContext transformApiResponseFromArray:response toClass:class inContext:self.context];
                                            }]
                                           map:^id(NSArray *result) {
                                               @strongify(self);
                                               return [result sortedArrayUsingDescriptors:@[[self getSortDescriptorTransportSortType:transportSortType]]];
                                           }]
                                          doNext:^(NSArray <Transport *> *result) {
                                              @strongify(self);
                                              [self.context save];
                                          }]
                                         catch:^RACSignal *(NSError *error) {
                                             // If no internet connection return cached data - only as example
                                             if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == -1009) {
                                                 return cachedDataSignal;
                                             }
                                             return [RACSignal error:error];
                                         }]
                                        deliverOnMainThread];

        return networkDataSignal;
    }
}

- (nonnull RACSignal *)fetchCachedTransportsSortedBy:(TransportSortType)transportSortType {
    return [[self.context signalForExecuteFetchRequest:[self getFetchRequestForTransportSortType:transportSortType]]
                                   deliverOnMainThread];
}

#pragma mark - Helpers
- (Class)getClass {
    switch (self.transportType) {
        case TransportTypeBus:
            return [Bus class];

        case TransportTypeFlight:
            return [Flight class];

        case TransportTypeTrain:
            return [Train class];

        default:
            return nil;
    }
}

- (NSString *)getUrl {
    switch (self.transportType) {
        case TransportTypeBus:
            return GoEuroApiBusesEndpoint;

        case TransportTypeFlight:
            return GoEuroApiFlightsEndpoint;

        case TransportTypeTrain:
            return GoEuroApiTrainsEndpoint;

        default:
            return nil;
    }
}

- (NSSortDescriptor *)getSortDescriptorTransportSortType:(TransportSortType)sortType {
    switch (sortType) {
        case TransportSortTypeDepartureTime:
            return [[self getClass] departureTimeSortDescriptor];

        case TransportSortTypeArrivalTime:
            return [[self getClass] arrivalTimeSortDescriptor];

        case TransportSortTypeDuration:
            return [[self getClass] durationSortDescriptor];

        default:
            return [[self getClass] departureTimeSortDescriptor];
    }
}

- (NSFetchRequest *)getFetchRequestForTransportSortType:(TransportSortType)sortType {
    NSSortDescriptor *sortDescriptor = [self getSortDescriptorTransportSortType:sortType];

    return [[self getClass] fetchRequestWithSortDescriptor:sortDescriptor];
}

@end
