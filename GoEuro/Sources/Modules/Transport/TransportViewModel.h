//
//  TransportViewModel.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransportDAO.h"
// Models
#import "TransportTableCellViewModel.h"
#import "Transport+CoreDataClass.h"
#import "GoEuro-Swift.h"

@protocol TransportViewModelDelegate <NSObject>

- (void)didLoadTransports;
- (void)updateLoadingState:(BOOL)isLoading;
- (void)showErrorWithTitle:(nonnull NSString *)title text:(nonnull NSString *)text;
- (void)updateOptionsVisibility:(BOOL)isVisible;
- (void)updateNoDataVisibility:(BOOL)isVisible;

@end

@interface TransportViewModel : NSObject

#pragma mark - Properties
@property (assign, readonly, nonatomic) TransportType transportType;
@property (strong, nonatomic, nonnull) TransportDAO *transportDAO;
@property (strong, nonatomic, nonnull) NSArray <TransportTableCellViewModel *> *transportCellViewModels;
@property (weak, nonatomic, nullable) NSObject<TransportViewModelDelegate> *delegate;

#pragma mark - Initialization
- (nonnull instancetype)initWithTransportType:(TransportType)transportType router:(nonnull id<TransportRouting>)router;

#pragma mark - Methods
- (void)viewLoaded;
- (void)getTransports;
- (void)getTransportsSortedBy:(TransportSortType)transportSortType;
- (void)selectedTransportWithIndex:(NSInteger)index;

@end
