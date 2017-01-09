//
//  GoEuroTransportDaoTests.m
//  GoEuroTransportDaoTests
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <XCTest/XCTest.h>
// Models
#import "Transport+CoreDataClass.h"
#import "Bus+CoreDataClass.h"
#import "Train+CoreDataClass.h"
#import "Flight+CoreDataClass.h"
// Others
#import "GoEuroTestHelpers.h"
#import "TransportDAO.h"
#import "NSManagedObjectContext+Helpers.h"
#import "MockNetworking.h"

@interface GoEuroTransportDaoTests : XCTestCase

@property (strong, nonatomic, nonnull) NSManagedObjectContext *moc;
@property (strong, nonatomic, nonnull) MockNetworking *mockApi;
@property (strong, nonatomic, nonnull) TransportDAO *transportDAO;

@end

@implementation GoEuroTransportDaoTests

#pragma mark - Setup
- (void)setUp {
    [super setUp];

    self.moc = [GoEuroTestHelpers mockManagedObjectContext];
    self.mockApi = [[MockNetworking alloc] init];
    [self configureTransportDAOForTransportType:TransportTypeBus];
}

- (void)tearDown {
    [super tearDown];
}

- (void)configureTransportDAOForTransportType:(TransportType)transportType {
    self.transportDAO = [[TransportDAO alloc] initWithTransportType:transportType networking:self.mockApi withContext:self.moc];
}

#pragma mark - Tests
- (void)testFetchDataSortedByDepartureTime {
    __block BOOL success;
    __block NSError *error;

    RACSignal *signal = [self.transportDAO fetchTransportsSortedBy:TransportSortTypeDepartureTime];

    NSArray <Transport *> *transports = [signal asynchronousFirstOrDefault:nil success:&success error:&error];
    Transport *firstTransport = [transports firstObject];
    XCTAssert(firstTransport.idKey == 1, @"Data should be sorted by departure time");
}

- (void)testFetchDataSortedByArrivalTime {
    __block BOOL success;
    __block NSError *error;

    RACSignal *signal = [self.transportDAO fetchTransportsSortedBy:TransportSortTypeArrivalTime];

    NSArray <Transport *> *transports = [signal asynchronousFirstOrDefault:nil success:&success error:&error];
    Transport *firstTransport = [transports firstObject];
    XCTAssert(firstTransport.idKey == 2, @"Data should be sorted by arrival time");
}

- (void)testFetchDataSortedByDuration {
    __block BOOL success;
    __block NSError *error;

    RACSignal *signal = [self.transportDAO fetchTransportsSortedBy:TransportSortTypeDuration];

    NSArray <Transport *> *transports = [signal asynchronousFirstOrDefault:nil success:&success error:&error];
    Transport *firstTransport = [transports firstObject];
    XCTAssert(firstTransport.idKey == 3, @"Data should be sorted by duration");
}

- (void)testDataIsOfTypeBus {
    __block BOOL success;
    __block NSError *error;

    [self configureTransportDAOForTransportType:TransportTypeBus];

    RACSignal *signal = [self.transportDAO fetchTransportsSortedBy:TransportSortTypeDuration];

    NSArray <Transport *> *transports = [signal asynchronousFirstOrDefault:nil success:&success error:&error];
    Class class = [[transports firstObject] class];
    XCTAssert(class == [Bus class], @"Data should be of type Bus");
}

- (void)testDataIsOfTypeTrain {
    __block BOOL success;
    __block NSError *error;

    [self configureTransportDAOForTransportType:TransportTypeTrain];

    RACSignal *signal = [self.transportDAO fetchTransportsSortedBy:TransportSortTypeDuration];

    NSArray <Transport *> *transports = [signal asynchronousFirstOrDefault:nil success:&success error:&error];
    Class class = [[transports firstObject] class];
    XCTAssert(class == [Train class], @"Data should be of type Train");
}

- (void)testDataIsOfTypeFlight {
    __block BOOL success;
    __block NSError *error;

    [self configureTransportDAOForTransportType:TransportTypeFlight];

    RACSignal *signal = [self.transportDAO fetchTransportsSortedBy:TransportSortTypeDuration];

    NSArray <Transport *> *transports = [signal asynchronousFirstOrDefault:nil success:&success error:&error];
    Class class = [[transports firstObject] class];
    XCTAssert(class == [Flight class], @"Data should be of type Flight");
}

- (void)testIsFetchingFromCacheIfNoInternetConnection {
    __block BOOL success;
    __block NSError *error;
    Flight *flight = [NSEntityDescription insertNewObjectForEntityForName:@"Bus" inManagedObjectContext:self.moc];
    flight.idKey = 100;
    flight.departureTime = [NSDate new];
    flight.arrivalTime = [NSDate dateWithTimeIntervalSinceNow:3600];
    flight.numberOfStops = 2;
    flight.priceInEuros = 10.99;
    [self.moc save];

    NSArray <Bus *> *addedBuses = [self.moc executeFetchRequest:[Bus fetchRequest] error:&error];
    if (error) {
        XCTFail(@"Can't fetch Buses from the moc");
    }

    self.mockApi.networkReachable = NO;
    RACSignal *fetchFromCoreDataSignal = [self.transportDAO fetchTransportsSortedBy:TransportSortTypeDepartureTime];
    NSArray <Bus *> *daoBuses = [fetchFromCoreDataSignal asynchronousFirstOrDefault:nil success:&success error:&error];
    XCTAssert(daoBuses.count == addedBuses.count &&
              [daoBuses firstObject].idKey == [addedBuses firstObject].idKey,
              @"There should be one Bus in core data");
}

@end
