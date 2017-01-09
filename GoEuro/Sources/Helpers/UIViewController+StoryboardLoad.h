//
//  UIViewController+StoryboardLoad.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (StoryboardLoad)

#pragma mark - Class
+ (nonnull instancetype)loadFromStoryboardWithName:(nonnull NSString *)storyboardName;

@end
