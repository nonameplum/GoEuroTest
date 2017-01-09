//
//  TransportTableViewCell.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransportTableCellViewModel.h"

extern CGFloat const TransportTableViewCellHeight;

@interface TransportTableViewCell : UITableViewCell <TransportTableCellViewModelDelegate>

#pragma mark - Properties
@property (strong, nonatomic, nonnull) TransportTableCellViewModel *viewModel;

@end
