//
//  BalanceViewController.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "BalanceViewController.h"
#import "DataManager.h"
#import "BalanceViewModel.h"

#import "ReactiveCocoa.h"

#import "AlertHelper.h"

@interface BalanceViewController () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;


@end

@implementation BalanceViewController

#pragma mark - Managing the detail item

- (void)setPerson:(PersonViewModel*)person {
    if (_person != person) {
        _person = person;
        self.navigationItem.title = person.nameText;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Balance" inManagedObjectContext:[[DataManager shared] defaultContext]];
    [fetchRequest setEntity:entity];
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *currencyDescriptor = [[NSSortDescriptor alloc] initWithKey:@"currency" ascending:NO];
    
    NSSortDescriptor *amountDescriptor = [[NSSortDescriptor alloc] initWithKey:@"amount" ascending:NO];

    NSArray *sortDescriptors = @[currencyDescriptor, amountDescriptor];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"userId == %@", self.person.person.userId]];
    [fetchRequest setSortDescriptors:sortDescriptors];

    
    self.fetchedResultsController = [[DataManager shared] fetchedResultsControllerWithFetchRequest:fetchRequest];
    self.fetchedResultsController.delegate = self;
    
    [self loadData:nil];
    
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadData:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [refreshControl endRefreshing];
        });
    }];
}

- (void)loadData:(void (^)(void))completion {
    @weakify(self)
    [[DataManager shared] loadBalanceForPerson:self.person.person completion:^(ResponseObject *response) {
        @strongify(self)
        UIAlertController *alert = [AlertHelper alertControllerWith:response retryAction:^{
            @strongify(self)
            [self loadData:nil];
        }];
        if (alert) [self presentViewController:alert animated:YES completion:nil];
        if (completion) completion();
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    BalanceViewModel *object = [[BalanceViewModel alloc] initWithBalance:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    [self configureCell:cell withObject:object];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(BalanceViewModel *)object {
    cell.textLabel.text = object.balanceString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}
@end
