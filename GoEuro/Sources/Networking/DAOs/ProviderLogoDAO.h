//
//  ProviderLogoDAO.h
//  GoEuro
//
//  Created by Łukasz Śliwiński on 05/01/2017.
//  Copyright © 2016 Łukasz Śliwiński. All rights reserved.
//

#import "BaseDAO.h"
#import <Foundation/Foundation.h>

@interface ProviderLogoDAO : BaseDAO

#pragma mark - Methods
- (nonnull RACSignal *)getProviderLogoFromURL:(nonnull NSString *)url;

@end
