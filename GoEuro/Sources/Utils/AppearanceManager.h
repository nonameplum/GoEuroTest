//
//  AppearanceManager.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppearanceManager : NSObject

#pragma mark - Properties
@property (strong, nonatomic, readonly, nonnull) UIColor *blueColor;
@property (nonatomic, readonly) CGFloat fontSize1;
@property (nonatomic, readonly) CGFloat fontSize2;
@property (nonatomic, readonly) CGFloat fontSize3;
@property (nonatomic, readonly) CGFloat fontSize4;
@property (nonatomic, readonly) CGFloat fontSize5;

#pragma mark - Initialization
- (nonnull instancetype)init NS_UNAVAILABLE;

#pragma mark - Class
+ (nonnull instancetype)sharedInstance;

#pragma mark - Methods
- (void)setupAppearance;
- (nonnull UILabel *)titleLabelWithTitle:(nonnull NSString *)title andSubtitle:(nonnull NSString *)subtitle;
- (nonnull UIFont *)appFontWithSize:(CGFloat)size;

@end
