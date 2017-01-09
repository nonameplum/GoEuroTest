//
//  MainViewController.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "MainViewController.h"
// Views
#import "TransportViewController.h"
#import "TransportsTabBar.h"
// Models
#import "TransportType.h"
// Others
#import "AppearanceManager.h"
#import "MainRouter.h"

@interface MainViewController () <UITabBarControllerDelegate, TransportsTabBarDelegate>

// IBOutlets
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIView *viewControllerContainerView;
@property (weak, nonatomic) IBOutlet TransportsTabBar *transportsTabBar;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;

// Properties
@property (strong, nonatomic, nonnull) UITabBarController *tabBarController;
@property (strong, nonatomic, nonnull) MainRouter *mainRouter;

@end

@implementation MainViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    self.mainRouter = [[MainRouter alloc] initWithController:self];
    [self setupTitle:@"Berlin - Londyn" withSubtitle:@"Jun 07"];
    [self setupTransportTabBar];
    [self setupBottomToolbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self configureTabBarController];
}

#pragma mark - Appearance
- (void)setupTransportTabBar {
    self.transportsTabBar.delegate = self;
    self.transportsTabBar.backgroundColor = [[AppearanceManager sharedInstance] blueColor];
}

- (void)setupBottomToolbar {
    self.bottomContainerView.backgroundColor = [[AppearanceManager sharedInstance] blueColor];
    self.bottomToolbar.translucent = NO;
    self.bottomToolbar.barTintColor = [[AppearanceManager sharedInstance] blueColor];
}

- (void)setupTitle:(NSString *)title withSubtitle:(NSString *)subtitle {
    self.navigationItem.titleView = [[AppearanceManager sharedInstance] titleLabelWithTitle:title andSubtitle:subtitle];
}

#pragma mark - Helpers
- (void)configureTabBarController {
    if (self.tabBarController) {
        return;
    }

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    // Hide default tabBar because custom controll will be used
    self.tabBarController.tabBar.hidden = YES;

    UIViewController *trainViewController = [[TransportViewController alloc] initWithTransportType:TransportTypeTrain];
    UIViewController *busViewController = [[TransportViewController alloc] initWithTransportType:TransportTypeBus];
    UIViewController *flightViewController = [[TransportViewController alloc] initWithTransportType:TransportTypeFlight];

    self.tabBarController.viewControllers = @[trainViewController, busViewController, flightViewController];

    // Add tabBarController as a child view controller
    [self addChildViewController:self.tabBarController];
    self.tabBarController.view.frame = self.viewControllerContainerView.bounds;
    self.tabBarController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.viewControllerContainerView addSubview:self.tabBarController.view];
    [self.tabBarController didMoveToParentViewController:self];

    // Move selection indicator to the initial position
    [self updateTabBarSelectionIdicatorWithViewController:self.tabBarController.selectedViewController];
}

- (void)updateTabBarSelectionIdicatorWithViewController:(UIViewController *)viewController {
    if (![viewController isKindOfClass:[TransportViewController class]]) {
        return;
    }
    TransportViewController *transportViewController = (TransportViewController *)viewController;
    [self.transportsTabBar moveSelectionIndicatorAccordingToTransportType:[transportViewController transportType]];
}

#pragma mark - TransportsTabBarDelegate
- (void)didSelelectButtonForTransportType:(TransportType)transportType {
    [self.mainRouter selectViewControllerInTabBarWithTransportType:transportType];
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    // Update selection indicator when tabBarController's selectedViewController changed
    [self updateTabBarSelectionIdicatorWithViewController:viewController];
}

@end
