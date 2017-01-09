//
//  MainRouter.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2017 Łukasz Śliwiński. All rights reserved.
//

#import "MainRouter.h"
#import "TransportTabBarControllerAnimator.h"

@interface MainRouter ()

@property (weak, nonatomic, nullable) MainViewController *controller;
@property (strong, nonatomic, nonnull) TransportTabBarControllerAnimator *tabBarControllerAnimator;

@end

@implementation MainRouter

#pragma mark - Initialization
- (instancetype)initWithController:(MainViewController *)controller {
    self = [super init];
    if (self) {
        _controller = controller;
        _tabBarControllerAnimator = [[TransportTabBarControllerAnimator alloc] init];
    }
    return self;
}

#pragma mark - Methods
- (void)selectViewControllerInTabBarWithTransportType:(TransportType)transportType {
    NSInteger destinationTabIndex = -1;
    switch (transportType) {
        case TransportTypeTrain:
            destinationTabIndex = 0;
            break;
        case TransportTypeBus:
            destinationTabIndex = 1;
            break;

        case TransportTypeFlight:
            destinationTabIndex = 2;
            break;

        default:
            return;
    }

    [self.tabBarControllerAnimator animateTransitionTabBarController:self.controller.tabBarController toControllerIndex:destinationTabIndex];
}

@end
