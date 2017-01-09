//
//  CoreDataScheduler.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CoreDataScheduler : RACScheduler

#pragma mark - Properties
@property (strong, nonatomic, readonly, nonnull) NSManagedObjectContext *context;

#pragma mark - Initialization
- (nonnull instancetype)initWithContext:(nonnull NSManagedObjectContext *)context NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init NS_UNAVAILABLE;


@end
