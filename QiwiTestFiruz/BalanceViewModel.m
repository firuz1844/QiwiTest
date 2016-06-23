//
//  BalanceViewModel.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "BalanceViewModel.h"

@implementation BalanceViewModel

- (instancetype)initWithBalance:(Balance*)balance {
    
    self = [super init];
    if (self) {
        _balance = balance;
        _balanceString = [NSString stringWithFormat:@"%@ - %@", balance.amount, balance.currency];
    }
    return self;
}

@end
