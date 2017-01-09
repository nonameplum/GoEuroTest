//
//  TransportsTabBar.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "TransportsTabBar.h"
#import "TransportType.h"

NSInteger const TransportsTabBarBarHeight = 6;

@interface TransportsTabBar ()

// IBOutlets
@property (weak, nonatomic) IBOutlet UIButton *trainButton;
@property (weak, nonatomic) IBOutlet UIButton *busButton;
@property (weak, nonatomic) IBOutlet UIButton *flightButton;

// Properties
@property (strong, nonatomic, nonnull) UIView *selectionIdicatorView;
@property (weak, nonatomic, nullable) UIButton *selectedButton;

@end

@implementation TransportsTabBar

#pragma mark - Initialization
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    UIView *view = [self loadViewFromNib];
    view.frame = self.bounds;
    view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self addSubview:view];
}

#pragma mark - Actions
- (IBAction)trainBarButtonTapped:(UIButton *)sender {
    [self.delegate didSelelectButtonForTransportType:TransportTypeTrain];
}

- (IBAction)busBarButtonTapped:(UIButton *)sender {
    [self.delegate didSelelectButtonForTransportType:TransportTypeBus];
}

- (IBAction)flightBarButtonTapped:(UIButton *)sender {
    [self.delegate didSelelectButtonForTransportType:TransportTypeFlight];
}

#pragma mark - Methods

/**
 Moves with animation the selected indicator to the destinated button according to the passed transport type.

 @param transportType destination transport type to which the selected indicator should move. 
 */
- (void)moveSelectionIndicatorAccordingToTransportType:(TransportType)transportType {
    UIButton *barButton = nil;
    switch (transportType) {
        case TransportTypeBus:
            barButton = self.busButton;
            break;

        case TransportTypeTrain:
            barButton = self.trainButton;
            break;

        case TransportTypeFlight:
            barButton = self.flightButton;
            break;

        default:
            return;
    }

    self.selectedButton = barButton;
    [self animateSelectionIndicatorToSelectedBarButtonAnimated:YES];
}

#pragma mark - Helpers
- (void)animateSelectionIndicatorToSelectedBarButtonAnimated:(BOOL)animated {
    if (!self.selectedButton) {
        return;
    }

    BOOL firstTime = NO;

    if (![self.subviews containsObject:self.selectionIdicatorView]) {
        self.selectionIdicatorView = [[UIView alloc] initWithFrame:CGRectZero];
        self.selectionIdicatorView.translatesAutoresizingMaskIntoConstraints = false;
        self.selectionIdicatorView.alpha = 0.0;
        [self addSubview:self.selectionIdicatorView];
        self.selectionIdicatorView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.2];


        [self.selectionIdicatorView addConstraint:[NSLayoutConstraint constraintWithItem:self.selectionIdicatorView
                                                                               attribute:NSLayoutAttributeHeight
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:nil
                                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                                              multiplier:1
                                                                                constant:TransportsTabBarBarHeight]];
        firstTime = YES;
    }


    NSArray *constraintsToRemove = [self.constraints objectsAtIndexes:[self.constraints indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSLayoutConstraint *constraint = (NSLayoutConstraint *)obj;
        return constraint.secondItem == self.selectionIdicatorView;
    }]];

    [self layoutIfNeeded];
    [self.selectionIdicatorView layoutIfNeeded];

    [self removeConstraints:constraintsToRemove];


    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.selectedButton
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.selectionIdicatorView
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.selectedButton
                                                     attribute:NSLayoutAttributeRight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.selectionIdicatorView
                                                     attribute:NSLayoutAttributeRight
                                                    multiplier:1.0
                                                      constant:0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.selectionIdicatorView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0]];

    if (animated) {
        if (firstTime) {
            [self layoutIfNeeded];
            [UIView animateWithDuration:0.5 animations:^{
                self.selectionIdicatorView.alpha = 1.0;
            }];
        } else {
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^{
                [self layoutIfNeeded];
            } completion:nil];
        }
    } else {
        [self layoutIfNeeded];
    }
}

- (nonnull UIView *)loadViewFromNib {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UINib *viewNib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:bundle];
    UIView *view = (UIView *)[[viewNib instantiateWithOwner:self options:nil] firstObject];
    NSAssert(view, @"Cannot load TransportsTabBar view from nib file");
    return view;
}

@end
