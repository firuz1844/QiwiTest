//
//  PersonsViewController.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class BalanceViewController;

@interface PersonsViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) BalanceViewController *balanceViewController;

@end

