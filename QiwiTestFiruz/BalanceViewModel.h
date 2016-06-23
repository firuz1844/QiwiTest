//
//  BalanceViewModel.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Balance.h"

@interface BalanceViewModel : NSObject

- (instancetype)initWithBalance:(Balance *)balance;

@property (nonatomic, readonly) Balance *balance;

@property (nonatomic, readonly) NSString *balanceString;

@end
