//
//  MainRouter.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2017 Łukasz Śliwiński. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"
#import "TransportType.h"

@interface MainRouter : NSObject

#pragma mark - Initialization
- (instancetype)initWithController:(MainViewController *)controller NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Methods
- (void)selectViewControllerInTabBarWithTransportType:(TransportType)transportType;

@end
