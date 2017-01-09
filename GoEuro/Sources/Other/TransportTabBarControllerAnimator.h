//
//  TransportTabBarControllerAnimator.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransportTabBarControllerAnimator : NSObject

#pragma mark - Methods
- (void)animateTransitionTabBarController:(nonnull UITabBarController *)tabBarController toControllerIndex:(NSInteger)controllerIndex;

@end
