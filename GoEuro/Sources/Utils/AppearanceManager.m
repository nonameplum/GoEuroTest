//
//  AppearanceManager.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "AppearanceManager.h"
#import "UIImage+Color.h"
#import <UIKit/UIKit.h>

@interface AppearanceManager ()

@property (strong, nonatomic, readwrite, nonnull) UIColor *blueColor;
@property (nonatomic, readwrite) CGFloat fontSize1;
@property (nonatomic, readwrite) CGFloat fontSize2;
@property (nonatomic, readwrite) CGFloat fontSize3;
@property (nonatomic, readwrite) CGFloat fontSize4;
@property (nonatomic, readwrite) CGFloat fontSize5;
@property (strong, nonatomic, readwrite, nonnull) UIFont *appFont;

@end

@implementation AppearanceManager

#pragma mark - Initialization
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.blueColor = [UIColor colorWithRed:15.0/255.0 green:97.0/255.0 blue:163.0/255.0 alpha:1.0];
        self.appFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        self.fontSize1 = 8.0;
        self.fontSize2 = 12.0;
        self.fontSize3 = 16.0;
        self.fontSize4 = 18.0;
        self.fontSize5 = 22.0;
    }

    return self;
}

#pragma mark - Methods
- (void)setupAppearance {
    UIImage *blueColorImage = [UIImage imageFromColor:self.blueColor];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [[UINavigationBar appearance] setBackgroundImage:blueColorImage forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [UINavigationBar appearance].barTintColor = self.blueColor;
    [UINavigationBar appearance].shadowImage = [UIImage new];
}

- (UILabel *)titleLabelWithTitle:(NSString *)title andSubtitle:(NSString *)subtitle {
    NSDictionary *titleAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSFontAttributeName: [self appFontWithSize:self.fontSize3]};

    NSDictionary *subtitleAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                         NSFontAttributeName: [self appFontWithSize:self.fontSize2]};

    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:titleAttributes];
    NSMutableAttributedString *attrSubtitle = [[NSMutableAttributedString alloc]
                                               initWithString:[NSString stringWithFormat:@"%@%@", @"\n", subtitle] attributes:subtitleAttributes];
    [attrTitle appendAttributedString:attrSubtitle];

    UILabel *titleLabel = [UILabel new];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = attrTitle;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    return titleLabel;
}

#pragma mark - Helpers
- (UIFont *)appFontWithSize:(CGFloat)size {
    return [self.appFont fontWithSize:size];
}

#pragma mark - Class
+ (instancetype)sharedInstance {
    static AppearanceManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

@end
