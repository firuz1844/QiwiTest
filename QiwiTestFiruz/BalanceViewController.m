//
//  BalanceViewController.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "BalanceViewController.h"
#import "DataHelper.h"
#import "BalanceViewModel.h"

#import "ReactiveCocoa.h"

@interface BalanceViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *balances;

@end

@implementation BalanceViewController

#pragma mark - Managing the detail item

- (void)setPerson:(PersonViewModel*)person {
    if (_person != person) {
        _person = person;
        self.navigationItem.title = person.nameText;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.balances.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    BalanceViewModel *object = [self.balances objectAtIndex:indexPath.row];
    [self configureCell:cell withObject:object];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(BalanceViewModel *)object {
    cell.textLabel.text = object.balanceString;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
 
    @weakify(self)
    [[DataHelper shared] getBalanceForPerson:self.person.person success:^(NSArray<BalanceViewModel *> *balances) {
        @strongify(self)
        self.balances = balances;
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self)
            [self.tableView reloadData];
        });
        [refreshControl endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
