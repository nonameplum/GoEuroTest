//
//  JSONSerializable.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol JSONSerializable <NSObject>

+ (nullable instancetype)createFromJSON:(nonnull NSDictionary *)jsonDictionary context:(nonnull NSManagedObjectContext *)context;

@end
