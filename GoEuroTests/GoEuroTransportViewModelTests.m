//
//  GoEuroTransportViewModelTests.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2017 Łukasz Śliwiński. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TransportViewModel.h"
#import "MockNetworking.h"
#import "GoEuroTestHelpers.h"
#import "GoEuro-Swift.h"

@interface MockTransportRouter : NSObject <TransportRouting>

@property (assign, nonatomic, nullable) TransportTableCellViewModel *presentedTableCellViewModel;

@end

@implementation MockTransportRouter

- (void)presentTransportDetailsForTransportCellViewModel:(TransportTableCellViewModel *)transportCellViewModel {
    self.presentedTableCellViewModel = transportCellViewModel;
}

@end

@interface MockTransportViewModelDelegateHandler : NSObject <TransportViewModelDelegate>

// TransportViewModelDelegate Expectations
@property (strong, nonatomic, nullable) XCTestExpectation *didLoadTransportsExpectation;
@property (strong, nonatomic, nullable) XCTestExpectation *updateLoadingStateExpectation;
@property (strong, nonatomic, nullable) XCTestExpectation *showErrorStateExpectation;
@property (strong, nonatomic, nullable) XCTestExpectation *updateOptionsVisibilityExpectation;
@property (strong, nonatomic, nullable) XCTestExpectation *updateNoDataVisibilityExpectation;

// TransportViewModelDelegate Expectation Results
@property (assign, nonatomic) BOOL didLoadTransportsDelegateCalled;
@property (assign, nonatomic) BOOL updateLoadingStateDelagateValue;
@property (strong, nonatomic, nullable) NSString *showErrorWithTitleDelegateTextValue;
@property (assign, nonatomic) BOOL updateOptionsVisibilityDelegateValue;
@property (assign, nonatomic) BOOL updateNoDataVisibilityDelegateValue;

@end

@implementation MockTransportViewModelDelegateHandler

- (void)didLoadTransports {
    self.didLoadTransportsDelegateCalled = YES;
    [self.didLoadTransportsExpectation fulfill];
}

- (void)updateLoadingState:(BOOL)isLoading {
    self.updateLoadingStateDelagateValue = isLoading;
    [self.updateLoadingStateExpectation fulfill];
}

- (void)showErrorWithTitle:(nonnull NSString *)title text:(nonnull NSString *)text {
    self.showErrorWithTitleDelegateTextValue = text;
    [self.showErrorStateExpectation fulfill];
}

- (void)updateOptionsVisibility:(BOOL)isVisible {
    self.updateOptionsVisibilityDelegateValue = isVisible;
    [self.updateOptionsVisibilityExpectation fulfill];
}

- (void)updateNoDataVisibility:(BOOL)isVisible {
    self.updateNoDataVisibilityDelegateValue = isVisible;
    [self.updateNoDataVisibilityExpectation fulfill];
}

@end

@interface GoEuroTransportViewModelTests : XCTestCase

@property (strong, nonatomic, nullable) TransportViewModel *transportViewModel;
@property (weak, nonatomic, nullable) MockNetworking *mockApi;
@property (weak, nonatomic, nullable) MockTransportRouter *mockRouter;
@property (strong, nonatomic, nullable) MockTransportViewModelDelegateHandler *transportViewModelDelegateHandler;

@end

@implementation GoEuroTransportViewModelTests

- (void)setUp {
    [super setUp];

    MockTransportRouter *transportRouter = [[MockTransportRouter alloc] init];
    self.mockRouter = transportRouter;

    self.transportViewModel = [[TransportViewModel alloc] initWithTransportType:TransportTypeBus router:transportRouter];
    NSManagedObjectContext *moc = [GoEuroTestHelpers mockManagedObjectContext];

    MockNetworking *mockApi = [[MockNetworking alloc] init];
    self.mockApi = mockApi;

    TransportDAO *transportDAO = [[TransportDAO alloc] initWithTransportType:TransportTypeBus networking:mockApi withContext:moc];
    self.transportViewModel.transportDAO = transportDAO;

    self.transportViewModelDelegateHandler = [MockTransportViewModelDelegateHandler new];
    self.transportViewModel.delegate = self.transportViewModelDelegateHandler;
}

- (void)tearDown {
    self.transportViewModel = nil;
    [super tearDown];
}

- (void)testTransportViewModelNoData {
    self.mockApi.testDataJsonFileName = @"testEmptyData.json";
    self.transportViewModelDelegateHandler.updateNoDataVisibilityExpectation = [self expectationWithDescription:@"testTransportViewModelNoDataIsVisible"];

    [self.transportViewModel getTransports];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"waitForExpectationsWithTimeout errored %@", error);
        }

        XCTAssert(self.transportViewModelDelegateHandler.updateNoDataVisibilityDelegateValue == YES, @"Expected delegate with YES value called");
    }];

    self.mockApi.testDataJsonFileName = @"testBusData.json";
    self.transportViewModelDelegateHandler = [MockTransportViewModelDelegateHandler new];
    self.transportViewModelDelegateHandler.updateNoDataVisibilityExpectation = [self expectationWithDescription:@"testTransportViewModelNoDataIsHidden"];

    self.transportViewModel.delegate = self.transportViewModelDelegateHandler;

    [self.transportViewModel getTransports];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"waitForExpectationsWithTimeout errored %@", error);
        }

        XCTAssert(self.transportViewModelDelegateHandler.updateNoDataVisibilityDelegateValue == NO, @"Expected delegate with NO value called");
    }];
}

- (void)testLoadingDataAndPresentingSelectedTransportDetails {
    self.mockApi.testDataJsonFileName = @"testBusData.json";
    self.transportViewModelDelegateHandler.didLoadTransportsExpectation = [self expectationWithDescription:@"testTransportViewModelDidLoadCalled"];

    [self.transportViewModel getTransportsSortedBy:TransportSortTypeDepartureTime];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError * _Nullable error) {
        if (error) {
            XCTFail(@"waitForExpectationsWithTimeout errored %@", error);
        }

        XCTAssert(self.transportViewModelDelegateHandler.didLoadTransportsDelegateCalled == YES, @"Expected delegate with YES value called");

        [self.transportViewModel selectedTransportWithIndex:0];

        XCTAssert(self.mockRouter.presentedTableCellViewModel != nil &&
                  [self.mockRouter.presentedTableCellViewModel.numberOfStops isEqualToString:@"3 Stops"] &&
                  [self.mockRouter.presentedTableCellViewModel.priceIntegerPart isEqualToString:@"€5"] &&
                  [self.mockRouter.presentedTableCellViewModel.priceDecimalPart isEqualToString:@".48"],
                  @"Expected selected cell with id 1 from testBusData.json");
    }];
}

@end
