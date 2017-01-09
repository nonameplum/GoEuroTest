//
//  TransportTableViewCell.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "TransportTableViewCell.h"
#import "ProviderLogoDAO.h"
#import "AppearanceManager.h"

CGFloat const TransportTableViewCellHeight = 100.0;

@interface TransportTableViewCell ()

// IBOutlets
@property (weak, nonatomic) IBOutlet UIView *providerLogoContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *providerLogoImage;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfStops;

@end

@implementation TransportTableViewCell

#pragma mark - Getters/Setters
- (void)setViewModel:(TransportTableCellViewModel *)viewModel {
    _viewModel = viewModel;
    self.viewModel.delegate = self;
    self.timeLabel.text = self.viewModel.departureArrive;
    self.timeDurationLabel.text = self.viewModel.duration;
    self.numberOfStops.text = self.viewModel.numberOfStops;
    [self setupPriceLabel];
    [self.viewModel fetchProviderLogoImage];
}

#pragma mark - TransportTableCellViewModelDelegate
- (void)didFetchProviderLogoImage:(UIImage *)providerLogoImage {
    self.providerLogoImage.image = providerLogoImage;
    [self setupProviderLogoImageConstraintsForImageSize:providerLogoImage.size];
}

#pragma mark - Helpers
- (void)setupPriceLabel {
    AppearanceManager *appearanceManager = [AppearanceManager sharedInstance];
    UIFont *integerFont = [appearanceManager appFontWithSize:appearanceManager.fontSize4];
    NSDictionary *integerFontDict = [NSDictionary dictionaryWithObject:integerFont forKey:NSFontAttributeName];
    NSMutableAttributedString *priceTextAttributes = [[NSMutableAttributedString alloc] initWithString:self.viewModel.priceIntegerPart attributes: integerFontDict];

    UIFont *decimalFont = [appearanceManager appFontWithSize:appearanceManager.fontSize2];
    NSDictionary *attrDict = [NSDictionary dictionaryWithObject:decimalFont forKey:NSFontAttributeName];
    NSMutableAttributedString *decimalAttributes = [[NSMutableAttributedString alloc]initWithString:self.viewModel.priceDecimalPart attributes:attrDict];
    [priceTextAttributes appendAttributedString:decimalAttributes];

    self.priceLabel.attributedText = priceTextAttributes;
}

- (void)setupProviderLogoImageConstraintsForImageSize:(CGSize)imageSize {
    [self.providerLogoImage removeConstraints:self.providerLogoImage.constraints];

    [self.providerLogoImage.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.providerLogoImage
                                                                                 attribute:NSLayoutAttributeLeft
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.providerLogoContainerView
                                                                                 attribute:NSLayoutAttributeLeft
                                                                                multiplier:1.0
                                                                                  constant:0]];

    [self.providerLogoImage.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.providerLogoImage
                                                                                 attribute:NSLayoutAttributeBottom
                                                                                 relatedBy:NSLayoutRelationEqual
                                                                                    toItem:self.providerLogoContainerView
                                                                                 attribute:NSLayoutAttributeBottom
                                                                                multiplier:1.0
                                                                                  constant:0]];

    CGFloat desiredHeight = CGRectGetHeight(self.providerLogoImage.superview.frame);
    [self.providerLogoImage addConstraint:[NSLayoutConstraint constraintWithItem:self.providerLogoImage
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:desiredHeight]];

    CGFloat desiredWidth = (desiredHeight / imageSize.height) * imageSize.width;
    [self.providerLogoImage addConstraint:[NSLayoutConstraint constraintWithItem:self.providerLogoImage
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                                      multiplier:1.0
                                                                        constant:desiredWidth]];
}

@end
