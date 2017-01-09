//
//  UITableView+CellAnimation.m
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2017 Łukasz Śliwiński. All rights reserved.
//

#import "UITableView+CellAnimation.h"

@implementation UITableView (CellAnimation)


/**
 Custom table view rows animation. Spring animation from bottom to top.
 */
- (void)animateRows {

    for (int i = 0; i < self.visibleCells.count; i++) {
        UITableViewCell *cell = [self.visibleCells objectAtIndex:i];

        cell.alpha = 1.0;
        cell.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, CGRectGetHeight(self.bounds));
    }

    for (int i = 0; i < self.visibleCells.count; i++) {
        UITableViewCell *cell = [self.visibleCells objectAtIndex:i];

        [UIView animateWithDuration:0.7 delay:i*0.05 usingSpringWithDamping:0.6 initialSpringVelocity:0 options:0 animations:^{
            cell.transform = CGAffineTransformIdentity;
            cell.alpha = 1.0;
        } completion:nil];
    }
}

@end
