//
//  CoreDataManager.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "CoreDataManager.h"

#import "NSManagedObjectContext+Helpers.h"
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager ()

@property (strong, nonatomic, nonnull) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic, nonnull) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic, nonnull) NSManagedObjectContext *privateManagedObjectContext;
@property (strong, nonatomic, readwrite, nonnull) NSManagedObjectContext *managedObjectContext;

@end

@implementation CoreDataManager

#pragma mark - Initialization
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupNotifiactionHandling];
    }
    return self;
}

#pragma mark - Notification handling
- (void)setupNotifiactionHandling {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveChangesHandler:) name:UIApplicationWillTerminateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveChangesHandler:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSaveHandler:) name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void)saveChangesHandler:(NSNotification *)notification {
    [self saveChanges];
}

- (void)contextDidSaveHandler:(NSNotification *)notification {
    NSManagedObjectContext *context = notification.object;
    if (context && context != self.managedObjectContext && context.parentContext == self.managedObjectContext) {
        [self.managedObjectContext performBlock:^{
            [self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
            [self saveChanges];
        }];
    }
}

#pragma mark - CoreData stack
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"GoEuro" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];

    NSAssert(!!_managedObjectModel, @"Managed object model cannot be initialized.");

    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }

    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *url = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GoEuroCoreData.sqlite"];

    NSError *error = nil;
    [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];

    NSAssert(!error, @"There was an error creating or loading the application's saved data.");

    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)privateManagedObjectContext {
    if (_privateManagedObjectContext) {
        return _privateManagedObjectContext;
    }

    _privateManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _privateManagedObjectContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
    return _privateManagedObjectContext;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }

    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.parentContext = [self privateManagedObjectContext];
    return _managedObjectContext;
}

#pragma mark - Methods
- (NSManagedObjectContext *)createPrivateManagedObjectContext {
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context setParentContext:self.managedObjectContext];

    return context;
}

- (void)saveChanges {
    [self.managedObjectContext performBlockAndWait:^{
        if (self.managedObjectContext.hasChanges) {
            if (![self.managedObjectContext save]) {
                NSLog(@"Unable to save changes of managed object context");
            }
        }
    }];

    [self.privateManagedObjectContext performBlock:^{
        if (self.privateManagedObjectContext.hasChanges) {
            if (![self.privateManagedObjectContext save]) {
                NSLog(@"Unable to save changes of private managed object context");
            }
        }
    }];
}

#pragma mark - Class
+ (instancetype)sharedInstance {
    static CoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [CoreDataManager new];
    });
    return sharedInstance;
}

@end
