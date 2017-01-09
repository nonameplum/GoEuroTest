//
//  AppDelegate.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "AppDelegate.h"
#import "AppMainRouter.h"

@interface AppDelegate ()

@property (strong, nonatomic) AppMainRouter *appMainRouter;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.appMainRouter = [[AppMainRouter alloc] initWithWindow:self.window];
    [self.appMainRouter start];

    return YES;
}

@end
