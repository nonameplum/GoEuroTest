//
//  Flight+CoreDataProperties.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Flight+CoreDataProperties.h"

@implementation Flight (CoreDataProperties)

+ (NSFetchRequest<Flight *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Flight"];
}


@end
