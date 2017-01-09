//
//  CoreDataManager.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

#pragma mark - Properties
@property (strong, nonatomic, readonly, nonnull) NSManagedObjectContext *managedObjectContext;

#pragma mark - Methods
- (nonnull NSManagedObjectContext *)createPrivateManagedObjectContext;

#pragma mark - Class
+ (nonnull instancetype)sharedInstance;

@end
