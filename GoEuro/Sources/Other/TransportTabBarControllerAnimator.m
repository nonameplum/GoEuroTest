//
//  TransportTabBarControllerAnimator.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "TransportTabBarControllerAnimator.h"

@interface TransportTabBarControllerAnimator ()

@property (assign, nonatomic) BOOL isAnimating;

@end

@implementation TransportTabBarControllerAnimator

#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _isAnimating = false;
    }
    return self;
}

#pragma mark - Methods

/**
 Animate transition of currently selected view controller to the destination view controller.

 @param tabBarController tabBarController which is used to configure destination view controller.
 @param controllerIndex index of the controller in tabBarController that should be selected.
 */
- (void)animateTransitionTabBarController:(UITabBarController *)tabBarController toControllerIndex:(NSInteger)controllerIndex {
    if (tabBarController.selectedIndex == controllerIndex || self.isAnimating) {
        return;
    }

    self.isAnimating = YES;

    UIView *fromView = tabBarController.selectedViewController.view;
    UIView *toView = [[tabBarController.viewControllers objectAtIndex:controllerIndex] view];

    if (fromView == toView) {
        return;
    }

    [tabBarController.delegate tabBarController:tabBarController didSelectViewController:[tabBarController.viewControllers objectAtIndex:controllerIndex]];

    toView.frame = fromView.superview.bounds;
    [fromView.superview addSubview:toView];
    
    BOOL movementRight = controllerIndex > tabBarController.selectedIndex;

    CATransform3D toViewTransform = CATransform3DIdentity;
    toViewTransform.m34 = 1.0 / 500.0;
    toViewTransform = CATransform3DTranslate(toViewTransform, CGRectGetMaxX(toView.bounds) * (movementRight ? -1 : 1), 0, 0);
    toViewTransform = CATransform3DRotate(toViewTransform, 90 * M_PI / 180 * (movementRight ? 1 : -1), 0, 1, 0);
    toViewTransform = CATransform3DScale(toViewTransform, 0.6, 0.6, 1);
    toView.layer.transform = toViewTransform;
    toView.layer.opacity = 0.0;

    [UIView animateKeyframesWithDuration:0.6 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.4 animations:^{
            CATransform3D fromViewTransfrom = fromView.layer.transform;
            fromViewTransfrom.m34 = 1.0 / 500.0;
            fromViewTransfrom = CATransform3DRotate(fromViewTransfrom, 10 * M_PI / 180 * (movementRight ? -1 : 1), 0, 1, 0);
            fromViewTransfrom = CATransform3DTranslate(fromViewTransfrom, CGRectGetMaxX(fromView.bounds) * 0.1 * (movementRight ? 1 : -1), 0, 0);
            fromViewTransfrom = CATransform3DScale(fromViewTransfrom, 0.9, 0.9, 1);
            fromView.layer.transform = fromViewTransfrom;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.4 animations:^{
            CATransform3D toViewTransformAnimation = CATransform3DIdentity;
            toViewTransformAnimation.m34 = 1.0 / 500.0;
            toViewTransformAnimation = CATransform3DTranslate(toViewTransformAnimation, CGRectGetMaxX(toView.bounds) * 0.1 * (movementRight ? -1 : 1), 0, 0);
            toViewTransformAnimation = CATransform3DRotate(toViewTransformAnimation, 10 * M_PI / 180 * (movementRight ? 1 : -1), 0, 1, 0);
            toViewTransformAnimation = CATransform3DScale(toViewTransformAnimation, 0.9, 0.9, 1);
            toView.layer.transform = toViewTransformAnimation;
            toView.layer.opacity = 1.0;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.4 animations:^{
            fromView.layer.transform = CATransform3DTranslate(fromView.layer.transform, CGRectGetMaxX(fromView.bounds) * (movementRight ? 1 : -1), 0, 0);
            fromView.layer.transform = CATransform3DScale(fromView.layer.transform, 0.6, 0.6 , 1);
            fromView.layer.transform = CATransform3DRotate(fromView.layer.transform, 90 * M_PI / 180 * (movementRight ? -1 : 1), 0, 1, 0);
            fromView.layer.opacity = 0.0;
        }];

        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
            toView.layer.transform = CATransform3DIdentity;
        }];
    } completion:^(BOOL finished) {
        [fromView removeFromSuperview];

        toView.layer.transform = CATransform3DIdentity;
        toView.layer.opacity = 1.0;

        fromView.layer.transform = CATransform3DIdentity;
        fromView.layer.opacity = 1.0;

        tabBarController.selectedIndex = controllerIndex;

        self.isAnimating = NO;
    }];
}

@end
