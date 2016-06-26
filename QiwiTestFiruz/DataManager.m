//
//  DataManager.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "DataManager.h"
#import "RestHelper.h"
#import "FetchResultController.h"

#import "PersonViewModel.h"
#import "Person.h"
#import "BalanceViewModel.h"
#import "Balance.h"
#import "ResponseObject.h"

@interface DataManager()

@property (strong, nonatomic) RestHelper *restHelper;

@end

@implementation DataManager

static DataManager *DataManagerInstance = nil;

- (instancetype)initWithRestHelper:(RestHelper *)restHelper {
    self = [super init];
    if (self) {
        _restHelper = restHelper;
    }
    return self;
}

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DataManagerInstance = [[self alloc] initWithRestHelper:[RestHelper new]];
    });
    return DataManagerInstance;
}

- (void)loadPersons:(void (^)(ResponseObject *response))completion {
    [self clearResponses];
    [self.restHelper loadPersons:^(ResponseObject *response, NSError *error) {
        if (!error) {
            NSLog(@"%@", response);
        } else {
            NSLog(@"%@", error);
        }
        if(completion) completion(response);
    }];
}

- (void)loadBalanceForPerson:(Person*)person completion:(void (^)(ResponseObject *response))completion {
    [self clearBalances];
    [self clearResponses];
    [self.restHelper loadBalanceForPerson:person completion:^(ResponseObject *response, NSError *error) {
        if (!error) {
            NSLog(@"%@", response);
        } else {
            NSLog(@"%@", error);
        }
        if(completion) completion(response);
    }];
}

- (void)clearBalances{
    [self clearStoreForDataClass:[Balance class]];
}

- (void)clearResponses{
    [self clearStoreForDataClass:[ResponseObject class]];
}

- (void)clearStoreForDataClass:(Class)class {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass(class) inManagedObjectContext:self.restHelper.managedObjectContext]];
    [fetchRequest setIncludesPropertyValues:NO];
    
    NSError *error = nil;
    NSArray *objects = [self.restHelper.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *object in objects) {
        [self.restHelper.managedObjectContext deleteObject:object];
    }

}

#pragma mark - Fetched results controller

- (FetchResultController*)fetchedResultsControllerWithFetchRequest:(NSFetchRequest*)fetchRequest;
{
    
    FetchResultController *controller = [[FetchResultController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self defaultContext] sectionNameKeyPath:nil cacheName:nil];
    
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
