//
//  TransportTableCellViewModel.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TransportTableCellViewModelDelegate <NSObject>

- (void)didFetchProviderLogoImage:(nonnull UIImage *)providerLogoImage;

@end

@interface TransportTableCellViewModel : NSObject

#pragma mark - Properties
@property (strong, nonatomic, nullable) NSString *departureArrive;
@property (strong, nonatomic, nullable) NSString *duration;
@property (strong, nonatomic, nullable) NSString *priceIntegerPart;
@property (strong, nonatomic, nullable) NSString *priceDecimalPart;
@property (strong, nonatomic, nullable) NSString *numberOfStops;

@property (weak, nonatomic, nullable) id<TransportTableCellViewModelDelegate> delegate;

#pragma mark - Initialization
- (nonnull instancetype)initWithArrivalTime:(nullable NSDate *)arrivalTime
                              departureTime:(nullable NSDate *)departureTime
                                   duration:(NSInteger)duration
                              numberOfStops:(NSInteger)numberOfStops
                               priceInEuros:(float)priceInEuros
                            providerLogoURL:(nullable NSString *)providerLogoURL;

#pragma mark - Methods
- (void)fetchProviderLogoImage;

@end
