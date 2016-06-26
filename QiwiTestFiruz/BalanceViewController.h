//
//  BalanceViewController.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

/**
 ViewController knows only about view-models
 */
#import <UIKit/UIKit.h>

@class PersonViewModel;
@interface BalanceViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) PersonViewModel *person;

@end

