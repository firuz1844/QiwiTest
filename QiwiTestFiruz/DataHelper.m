//
//  DataHelper.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "DataHelper.h"
#import "RestHeper.h"

#import "Person.h"
#import "PersonViewModel.h"
#import "Balance.h"
#import "BalanceViewModel.h"

#import "NSArray+Mapper.h"

@interface DataHelper()

@property (nonatomic, strong) RestHeper *restHelper;
@property (strong, nonatomic, readwrite) NSFetchedResultsController *fetchedResultsController;

@end

@implementation DataHelper

static DataHelper *dataHelperInstance = nil;

- (instancetype)initWithRestHelper:(RestHeper *)restHelper {
    self = [super init];
    if (self) {
        _restHelper = restHelper;
    }
    return self;
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataHelperInstance = [[self alloc] initWithRestHelper:[RestHeper new]];
    });
    return dataHelperInstance;
}

- (void)getPersonsSuccess:(void (^)(NSArray<PersonViewModel*> *persons))success failure:(void (^)(NSError *error))failure {
    NSError *error;
    NSArray *persons = [self.restHelper fetchPersonsFromContextError:&error];
    if (persons) {
        success([self personViewModelsWithArray:persons]);
    } else {
        [self.restHelper loadPersonsSuccess:^(NSArray *persons) {
            success([self personViewModelsWithArray:persons]);
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
    NSLog(@"%@", error);
}

- (void)getBalanceForPerson:(Person*)person success:(void (^)(NSArray<BalanceViewModel*> *balances))success failure:(void (^)(NSError *error))failure {
    [self.restHelper loadBalanceForPerson:person success:^(NSArray *balances) {
        success([self balanceViewModelsWithArray:balances]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

- (NSArray*)personViewModelsWithArray:(NSArray*)array {
    NSArray *viewModels = [array mapWithBlock:^id(id model) {
        PersonViewModel *viewModel = [[PersonViewModel alloc] initWithPerson:model];
        return viewModel;
    }];
    return viewModels;
}

- (NSArray*)balanceViewModelsWithArray:(NSArray*)array {
    NSArray *viewModels = [array mapWithBlock:^id(id model) {
        BalanceViewModel *viewModel = [[BalanceViewModel alloc] initWithBalance:model];
        return viewModel;
    }];
    return viewModels;
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:self.restHelper.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.restHelper.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}


@end
