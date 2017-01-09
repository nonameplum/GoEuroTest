//
//  TransportDAO.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BaseDAO.h"
#import "TransportType.h"
#import "CoreDataScheduler.h"

@interface TransportDAO : BaseDAO

#pragma mark - Properties
@property (assign, nonatomic) TransportType transportType;

#pragma mark - Initialization
- (nonnull instancetype)initWithTransportType:(TransportType)transportType NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)initWithTransportType:(TransportType)transportType networking:(nonnull NetworkApi *)networking withContext:(nonnull NSManagedObjectContext *)context;
- (nonnull instancetype)init NS_UNAVAILABLE;

#pragma mark - Methods
- (nonnull RACSignal *)fetchTransportsSortedBy:(TransportSortType)transportSortType;
- (nonnull RACSignal *)fetchCachedTransportsSortedBy:(TransportSortType)transportSortType;

@end
