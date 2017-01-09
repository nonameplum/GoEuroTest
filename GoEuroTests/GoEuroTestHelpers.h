//
//  GoEuroTestHelpers.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2017 Łukasz Śliwiński. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoEuroTestHelpers : NSObject

+ (NSDictionary *)dictionaryWithContentsOfJSONString:(NSString *)fileLocation;
+ (NSManagedObjectContext *)mockManagedObjectContext;

@end
