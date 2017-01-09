//
//  SettingsManager.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "SettingsManager.h"

NSString *__nonnull const SettingsManagerBaseURL  = @"https://api.myjson.com/";

@implementation SettingsManager

#pragma mark - Class
+ (NSURL *)baseApiURL {
    return [NSURL URLWithString:SettingsManagerBaseURL];
}

@end
