//
//  TransportViewModel.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "TransportViewModel.h"
// Models
#import "TransportType.h"

@interface TransportViewModel ()

@property (assign, readwrite, nonatomic) TransportType transportType;
@property (strong, nonatomic, nonnull) NSArray <Transport *> *transports;
@property (assign, nonatomic) TransportSortType transportSortType;
@property (strong, nonatomic, nonnull) id<TransportRouting> router;
@property (assign, nonatomic) BOOL sortingOptionsVisible;
@property (assign, nonatomic) BOOL isLoadingData;
@property (assign, nonatomic) BOOL isNoDataViewVisible;

@end

@implementation TransportViewModel

#pragma mark - Getters/Setters
- (void)setTransportCellViewModels:(NSArray<TransportTableCellViewModel *> *)transportCellViewModels {
    _transportCellViewModels = transportCellViewModels;
    [self.delegate didLoadTransports];
}

- (void)setSortingOptionsVisible:(BOOL)sortingOptionsVisible {
    _sortingOptionsVisible = sortingOptionsVisible;
    [self.delegate updateOptionsVisibility:sortingOptionsVisible];
}

- (void)setIsLoadingData:(BOOL)isLoadingData {
    _isLoadingData = isLoadingData;
    [self.delegate updateLoadingState:isLoadingData];
}

- (void)setIsNoDataViewVisible:(BOOL)isNoDataViewVisible {
    if (_isNoDataViewVisible != isNoDataViewVisible) {
        _isNoDataViewVisible = isNoDataViewVisible;
        [self.delegate updateNoDataVisibility:isNoDataViewVisible];
    }
}

#pragma mark - Initialization
- (nonnull instancetype)initWithTransportType:(TransportType)transportType router:(nonnull id<TransportRouting>)router {
    self = [super init];
    if (self) {
        _transportType = transportType;
        _transportDAO = [[TransportDAO alloc] initWithTransportType:transportType];
        _transportSortType = TransportSortTypeDepartureTime;
        _router = router;
    }
    return self;
}

#pragma mark - Methods
- (void)viewLoaded {
    if (self.transportCellViewModels.count < 1) {
        [self getTransports];
    }

    [self updateSortingOptionsVisible];
}

- (void)getTransports {
    [self fetchTransportsSortedType:self.transportSortType];
}

- (void)getTransportsSortedBy:(TransportSortType)transportSortType {
    [self fetchTransportsSortedType:transportSortType];
}

- (void)selectedTransportWithIndex:(NSInteger)index {
    [self.router presentTransportDetailsForTransportCellViewModel:self.transportCellViewModels[index]];
}

#pragma mark - Helpers
- (void)fetchTransportsSortedType:(TransportSortType)transportSortType {
    self.isLoadingData = YES;
    self.isNoDataViewVisible = NO;

    RACSignal *fetchDataSignal = nil;
    if (self.transportCellViewModels.count > 0) {
        fetchDataSignal = [self.transportDAO fetchCachedTransportsSortedBy:transportSortType];
    } else {
        fetchDataSignal = [self.transportDAO fetchTransportsSortedBy:transportSortType];
    }

    @weakify(self);
    [[fetchDataSignal takeUntil:self.rac_willDeallocSignal]
     subscribeNext:^(NSArray *transports) {
         @strongify(self);
         self.transports = transports;
         [self mapTransportsToCellViewModels:transports];
     }
     error:^(NSError *error) {
         @strongify(self);
         [self.delegate showErrorWithTitle:@"" text:error.localizedDescription];
         self.isLoadingData = NO;
         [self updateSortingOptionsVisible];
         [self updateNoDataViewVisible];
     }
     completed:^{
         @strongify(self);
         self.isLoadingData = NO;
         [self updateSortingOptionsVisible];
         [self updateNoDataViewVisible];
     }];
}

- (void)mapTransportsToCellViewModels:(NSArray <Transport *> *)transports {
    NSMutableArray<TransportTableCellViewModel *> *cellViewModels = [[NSMutableArray alloc] init];

    for (Transport *transport in transports) {
        TransportTableCellViewModel *cellViewModel = [[TransportTableCellViewModel alloc] initWithArrivalTime:transport.arrivalTime
                                                                                                departureTime:transport.departureTime
                                                                                                     duration:(NSInteger)transport.duration
                                                                                                numberOfStops:(NSInteger)transport.numberOfStops
                                                                                                 priceInEuros:transport.priceInEuros
                                                                                              providerLogoURL:transport.providerLogo];
        [cellViewModels addObject:cellViewModel];
    }

    self.transportCellViewModels = cellViewModels;
}

- (void)updateSortingOptionsVisible {
    self.sortingOptionsVisible = self.transportCellViewModels.count > 0;
}

- (void)updateNoDataViewVisible {
    self.isNoDataViewVisible = self.transportCellViewModels.count < 1;
}

@end
