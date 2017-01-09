//
//  TransportTableCellViewModel.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "TransportTableCellViewModel.h"
#import "ProviderLogoDAO.h"

@interface TransportTableCellViewModel ()

// Properties
@property (strong, nonatomic, nonnull) ProviderLogoDAO *logoDAO;
@property (strong, nonatomic, nonnull) UIImage *providerLogoImage;
@property (strong, nonatomic, nullable) NSString *providerLogoURL;

@end

@implementation TransportTableCellViewModel

#pragma mark - Methods
- (nonnull instancetype)initWithArrivalTime:(nullable NSDate *)arrivalTime
                              departureTime:(nullable NSDate *)departureTime
                                   duration:(NSInteger)duration
                              numberOfStops:(NSInteger)numberOfStops
                               priceInEuros:(float)priceInEuros
                            providerLogoURL:(nullable NSString *)providerLogoURL {
    self = [super init];
    if (self) {
        [self setDepartureArriveWithDepartureTime:departureTime arrivalTime:arrivalTime];
        [self setPriceIntegerPartWithNumber:priceInEuros];
        [self setPriceDecimalPartWithNumber:priceInEuros];
        [self setDurationWithMinutes:duration];
        [self setNumberOfStopsWithNumber:numberOfStops];
        self.providerLogoURL = providerLogoURL;
    }
    return self;
}

- (void)fetchProviderLogoImage {
    if (!self.providerLogoImage) {
        @weakify(self);
        self.logoDAO = [[ProviderLogoDAO alloc] init];
        [[self.logoDAO getProviderLogoFromURL:self.providerLogoURL] subscribeNext:^(UIImage  * _Nullable image) {
            @strongify(self);
            self.providerLogoImage = image;
            [self.delegate didFetchProviderLogoImage:image];
        }];
    } else {
        [self.delegate didFetchProviderLogoImage:self.providerLogoImage];
    }
}

#pragma mark - Helpers
- (void)setDepartureArriveWithDepartureTime:(NSDate *)departureTime arrivalTime:(NSDate *)arrivalTime {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm"];

    self.departureArrive = [NSString stringWithFormat:@"%@ - %@",
                            [format stringFromDate:departureTime],
                            [format stringFromDate:arrivalTime]];
}

- (void)setPriceIntegerPartWithNumber:(float)number {
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    [format setNumberStyle:NSNumberFormatterNoStyle];
    self.priceIntegerPart = [NSString stringWithFormat:@"€%@", [format stringFromNumber: [NSNumber numberWithFloat:number]]];
}

- (void)setPriceDecimalPartWithNumber:(float)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.minimumFractionDigits = 2;
    formatter.maximumFractionDigits = 2;

    NSString *numberStr = [formatter stringFromNumber:[NSNumber numberWithFloat:number]];
    self.priceDecimalPart = [NSString stringWithFormat:@"%@%@", formatter.decimalSeparator, [[numberStr componentsSeparatedByString:formatter.decimalSeparator] lastObject]];
}

- (void)setDurationWithMinutes:(NSInteger)durationMinutes {
    NSInteger seconds = durationMinutes * 60;
    NSInteger minutes = (seconds / 60) % 60;
    NSInteger hours = seconds / 3600;

    self.duration = [NSString stringWithFormat:@"%02zd:%02zdh", hours, minutes];
}

- (void)setNumberOfStopsWithNumber:(NSInteger)number {
    self.numberOfStops = number > 1 ? [NSString stringWithFormat:@"%zd Stops", number] : @"Direct";
}

@end
