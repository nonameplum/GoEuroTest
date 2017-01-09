//
//  TransportViewController.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "TransportViewController.h"
// Views
#import "TransportTableViewCell.h"
// Models
#import "TransportViewModel.h"
// Others
#import "GoEuro-Swift.h"
#import "UIViewController+StoryboardLoad.h"
#import "UITableView+CellAnimation.h"
#import "AppearanceManager.h"

NSString *__nonnull const TransportViewControllerTransportCellIdentifier = @"TransportCell";

@interface TransportViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, TransportViewModelDelegate>

// IBOutlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet LoadingBar *loadingBarView;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomToolbar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionsHiddenConstraint;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

// Properties
@property (strong, nonatomic, nonnull) TransportViewModel *viewModel;


@end

@implementation TransportViewController

#pragma mark - StoryboardLoad
+ (nonnull NSString *)viewControllerId {
    return @"TransportViewController";
}

#pragma mark - Initialization
- (nonnull instancetype)initWithTransportType:(TransportType)transportType {
    self = [TransportViewController loadFromStoryboardWithName:@"Transport"];
    if (self) {
        TransportRouter *router = [[TransportRouter alloc] initWithController:self];
        _viewModel = [[TransportViewModel alloc] initWithTransportType:transportType router:router];
        _viewModel.delegate = self;
    }
    return self;
}

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureSortingOptions];
    [self setupBottomBarAppearance];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.viewModel viewLoaded];
}

#pragma mark - Appearance
- (void)setupBottomBarAppearance {
    self.bottomToolbar.translucent = NO;
    self.bottomToolbar.barTintColor = [[AppearanceManager sharedInstance] blueColor];
    self.bottomToolbar.tintColor = [UIColor whiteColor];
    self.bottomToolbar.clipsToBounds = YES;
}

#pragma mark - Configuration
- (void)configureSortingOptions {
    self.optionsHiddenConstraint.priority = UILayoutPriorityRequired-1;
}

#pragma mark - Actions
- (IBAction)sortBarButtonAction:(UIBarButtonItem *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Sort by:"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Departure time", @"Arrival time", @"Duration time", nil];
    [actionSheet showFromToolbar:self.bottomToolbar];
}

#pragma mark - Methods
- (TransportType)transportType {
    return self.viewModel.transportType;
}

#pragma mark - Helpers
- (TransportSortType)getTransportSortTypeForActionSheetButtonWithIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            return TransportSortTypeDepartureTime;

        case 1:
            return TransportSortTypeArrivalTime;

        case 2:
            return TransportSortTypeDuration;

        default:
            return TransportSortTypeNone;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return TransportTableViewCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.viewModel selectedTransportWithIndex:indexPath.row];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.transportCellViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransportTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TransportViewControllerTransportCellIdentifier];
    TransportTableCellViewModel *cellViewModel = self.viewModel.transportCellViewModels[indexPath.row];

    cell.viewModel = cellViewModel;

    return cell;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    TransportSortType sortType = [self getTransportSortTypeForActionSheetButtonWithIndex:buttonIndex];
    if (sortType == TransportSortTypeNone) {
        return;
    }
    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self.viewModel getTransportsSortedBy:sortType];
}

#pragma mark - TransportViewModelDelegate
- (void)didLoadTransports {
    [self.tableView reloadData];
    [self.tableView animateRows];
}

- (void)updateLoadingState:(BOOL)isLoading {
    if (isLoading) {
        [self.loadingBarView startLoading];
    } else {
        [self.loadingBarView stopLoading];
    }
}

- (void)showErrorWithTitle:(NSString *)title text:(NSString *)text {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:text delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)updateOptionsVisibility:(BOOL)isVisible {
    self.optionsHiddenConstraint.priority = isVisible ? UILayoutPriorityDefaultLow : UILayoutPriorityRequired-1;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)updateNoDataVisibility:(BOOL)isVisible {
    [UIView animateWithDuration:0.3 animations:^{
        self.noDataLabel.alpha = isVisible ? 1.0 : 0.0;
    } completion:^(BOOL finished) {
        self.noDataLabel.hidden = !isVisible;
    }];
}

@end
