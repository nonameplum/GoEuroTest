//
//  Transport+CoreDataProperties.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "Transport+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Transport (CoreDataProperties)

+ (NSFetchRequest<Transport *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *arrivalTime;
@property (nullable, nonatomic, copy) NSDate *departureTime;
@property (nonatomic) int64_t duration;
@property (nonatomic) int64_t idKey;
@property (nonatomic) int64_t numberOfStops;
@property (nonatomic) float priceInEuros;
@property (nullable, nonatomic, copy) NSString *providerLogo;

@end

NS_ASSUME_NONNULL_END
