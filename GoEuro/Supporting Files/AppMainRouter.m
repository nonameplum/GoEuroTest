//
//  AppMainRouter.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 30/12/2016.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "AppMainRouter.h"
#import "MainViewController.h"
#import "UIViewController+StoryboardLoad.h"
#import "AppearanceManager.h"

@interface AppMainRouter ()

@property (weak, nonatomic) UIWindow *window;

@end

@implementation AppMainRouter

#pragma mark - Initialization
- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (self) {
        self.window = window;
    }
    return self;
}

#pragma mark - Methods
- (void)start {
    [[AppearanceManager sharedInstance] setupAppearance];

    MainViewController *mainViewController = [MainViewController loadFromStoryboardWithName:@"MainStoryboard"];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
}

@end
