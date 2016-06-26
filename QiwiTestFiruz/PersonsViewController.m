//
//  PersonsViewController.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "PersonsViewController.h"
#import "BalanceViewController.h"
#import "FetchResultController.h"

#import "DataManager.h"
#import "PersonViewModel.h"

#import "ReactiveCocoa.h"

@interface PersonsViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) FetchResultController *fetchedResultsController;

@end

@implementation PersonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.balanceViewController = (BalanceViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:[[DataManager shared] defaultContext]];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"userId" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    self.fetchedResultsController = [[DataManager shared] fetchedResultsControllerWithFetchRequest:fetchRequest];
    self.fetchedResultsController.delegate = self;
    
    [self updateDataCompletion:nil];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self updateDataCompletion:^{
        [refreshControl endRefreshing];
    }];
}

- (void)updateDataCompletion:(void(^)(void))completion {
    [[DataManager shared] loadPersons:^(ResponseObject *response) {
        
        if (completion) completion();
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
        PersonViewModel *object = [self.fetchedResultsController viewModelAtIndexPath:indexPath];
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
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PersonViewModel *model = [self.fetchedResultsController viewModelAtIndexPath:indexPath];
    [self configureCell:cell withObject:model];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(PersonViewModel *)object {
    cell.textLabel.text = object.nameText;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

@end
