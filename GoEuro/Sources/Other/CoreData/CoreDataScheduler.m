//
//  CoreDataScheduler.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "CoreDataScheduler.h"

#import <CoreData/CoreData.h>
#import <ReactiveCocoa/RACScheduler+Subclass.h>

@interface CoreDataScheduler ()

@property (strong, nonatomic, readwrite, nonnull) NSManagedObjectContext *context;

@end

@implementation CoreDataScheduler

- (nonnull instancetype)initWithContext:(nonnull NSManagedObjectContext *)context {
    self = [super init];
    if (self) {
        _context = context;
    }

    return self;
}

- (RACDisposable *)schedule:(void (^)(void))block {
    NSParameterAssert(block);

    RACDisposable *disposable = [[RACDisposable alloc] init];

    [self.context performBlock:^{
        if (disposable.disposed) {
            return;
        }

        [self performAsCurrentScheduler:block];
    }];

    return disposable;
}

@end
