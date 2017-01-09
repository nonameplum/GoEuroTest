//
//  TransportViewController.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransportType.h"

@interface TransportViewController : UIViewController

#pragma mark - Initialization
- (nonnull instancetype)initWithTransportType:(TransportType)transportType;

#pragma mark - Methods
- (TransportType)transportType;

@end
