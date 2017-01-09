//
//  UIViewController+StoryboardLoad.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "UIViewController+StoryboardLoad.h"

@implementation UIViewController (StoryboardLoad)

#pragma mark - Class
#pragma mark Private
+ (nonnull NSString *)viewControllerId {
    return NSStringFromClass([self class]);
}

#pragma mark Public

/**
 Loads view controller from given storyboard.
 ViewController's storyboard id must be equal to self class name.

 @param storyboardName storyboard file name that will be used to initiate view controller
 @return view controller loaded from storyboard
 */
+ (instancetype)loadFromStoryboardWithName:(NSString *)storyboardName {
    NSBundle *storyboardBundle = [NSBundle bundleForClass:[self class]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:storyboardBundle];
    NSAssert(!!storyboard, @"Can't load storyboard file with name: %@", storyboardName);
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:[self viewControllerId]];
    NSAssert(!!controller, @"Can't load viewController for given identifier: %@", [self viewControllerId]);
    return controller;
}

@end
