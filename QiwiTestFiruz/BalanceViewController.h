//
//  BalanceViewController.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonViewModel.h"

@interface BalanceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) PersonViewModel *person;

@end

