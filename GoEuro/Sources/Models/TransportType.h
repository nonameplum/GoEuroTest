//
//  TransportType.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

typedef NS_ENUM(NSInteger, TransportType) {
    TransportTypeBus,
    TransportTypeFlight,
    TransportTypeTrain
};

typedef NS_ENUM(NSInteger, TransportSortType) {
    TransportSortTypeDepartureTime,
    TransportSortTypeArrivalTime,
    TransportSortTypeDuration,
    TransportSortTypeNone
};
