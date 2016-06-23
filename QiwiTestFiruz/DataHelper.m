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

@property (strong, nonatomic) RestHeper *restHelper;

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

- (void)updatePersons:(void (^)(void))completion {
    [self.restHelper loadPersons:completion];
}

- (void)loadBalanceForPerson:(Person*)person completion:(void (^)(void))completion {
    [self.restHelper loadBalanceForPerson:person completion:completion];
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

- (NSFetchedResultsController*)fetchedResultsControllerWithFetchRequest:(NSFetchRequest*)fetchRequest;
{
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self defaultContext] sectionNameKeyPath:nil cacheName:nil];
    
    NSError *error = nil;
    if (![controller performFetch:&error]) {
        NSLog(@"Error performing fetch %@, %@", error, [error userInfo]);
        abort();
    }
    
    return controller;
}

- (NSManagedObjectContext*)defaultContext {
    return self.restHelper.managedObjectContext;
}


@end
