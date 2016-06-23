//
//  PersonsViewController.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "PersonsViewController.h"
#import "BalanceViewController.h"

#import "DataHelper.h"
#import "PersonViewModel.h"

@interface PersonsViewController ()

@property (nonatomic, strong) NSArray *persons;

@end

@implementation PersonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.balanceViewController = (BalanceViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    __weak typeof(self) weakSelf = self;
    [[DataHelper shared] getPersonsSuccess:^(NSArray<PersonViewModel *> *persons) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.persons = persons;
            [strongSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Segues

static NSString * const kShowBalanceSegueIdentifier = @"showBalances";

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:kShowBalanceSegueIdentifier]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PersonViewModel *object = [self.persons objectAtIndex:indexPath.row];
        BalanceViewController *controller = (BalanceViewController *)[[segue destinationViewController] topViewController];
        [controller setPerson:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PersonViewModel *object = [self.persons objectAtIndex:indexPath.row];
    [self configureCell:cell withObject:object];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(PersonViewModel *)object {
    cell.textLabel.text = object.nameText;
}

@end
