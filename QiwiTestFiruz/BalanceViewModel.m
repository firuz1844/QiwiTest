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

        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.locale = [NSLocale currentLocale];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        formatter.currencyCode = balance.currency;
        
        _balanceString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:balance.amount]];
    }
    return self;
}

@end
