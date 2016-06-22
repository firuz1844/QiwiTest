//
//  DataHelper.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "DataHelper.h"
#import "Person.h"
#import "Balance.h"
#import "RestHeper.h"

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

- (void)getPersonsSuccess:(void (^)(NSArray *persons))success failure:(void (^)(NSError *error))failure {
    NSArray *persons = [self.restHelper fetchPersonsFromContext];
    if (persons) {
        success(persons);
    } else {
        [self.restHelper loadPersonsSuccess:^(NSArray *persons) {
            success(persons);
        } failure:^(NSError *error) {
            failure(error);
        }];
    }
}

- (void)getBalanceSuccess:(void (^)(NSArray *balances))success failure:(void (^)(NSError *error))failure {
    [self.restHelper loadBalanceSuccess:^(NSArray *balances) {
        success(balances);
    } failure:^(NSError *error) {
        failure(error);
    }];
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
