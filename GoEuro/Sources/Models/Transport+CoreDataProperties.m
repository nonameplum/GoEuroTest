//
//  Transport+CoreDataProperties.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "Transport+CoreDataProperties.h"


@implementation Transport (CoreDataProperties)

+ (NSFetchRequest<Transport *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Transport"];
}

@dynamic arrivalTime;
@dynamic departureTime;
@dynamic duration;
@dynamic idKey;
@dynamic numberOfStops;
@dynamic priceInEuros;
@dynamic providerLogo;

@end
