//
//  AppMainRouter.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 30/12/2016.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppMainRouter : NSObject

#pragma mark - Initialization
- (nonnull instancetype)initWithWindow:(nonnull UIWindow *)window NS_DESIGNATED_INITIALIZER;
- (nonnull instancetype)init NS_UNAVAILABLE;

#pragma mark - Methods
- (void)start;

@end
