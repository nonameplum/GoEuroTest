//
//  TransportsTabBar.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransportType.h"

@protocol TransportsTabBarDelegate <NSObject>

- (void)didSelelectButtonForTransportType:(TransportType)transportType;

@end

IB_DESIGNABLE
@interface TransportsTabBar : UIView

#pragma mark - Properties
@property (weak, nonatomic, nullable) id<TransportsTabBarDelegate> delegate;

#pragma mark - Methods
- (void)moveSelectionIndicatorAccordingToTransportType:(TransportType)transportType;

@end
