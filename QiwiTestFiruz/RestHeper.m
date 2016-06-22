//
//  RestHeper.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "RestHeper.h"

#import <RestKit/CoreData.h>
#import <RestKit/RestKit.h>

#import "Person.h"


static NSString * const kBaseUrl = @"https://w.qiwi.com";
static NSString * const kPersonsPath = @"/mobile/testtask/index.json";
static NSString * const kPersonsKeyPath = @"users";
static NSString * const kBalancePath = @"/mobile/testtask/users/%@/index.json";
static NSString * const kBalanceKeyPath = @"balances";


@interface RestHeper()

@property (nonatomic, strong) RKObjectManager *objectManager;

@end


@implementation RestHeper

-(instancetype)init {
    self = [super init];
    if (self) {
        NSURL *baseUrl = [NSURL URLWithString:kBaseUrl];
        self.objectManager = [RKObjectManager managerWithBaseURL:baseUrl];
        [self setup];
    }
    return self;
}

- (void)setup {
    
    NSError *error = nil;
    
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"QiwiTestFiruz" ofType:@"momd"]];
    
    NSManagedObjectModel *managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    
    // Initialize the Core Data stack
    [managedObjectStore createPersistentStoreCoordinator];
    
    NSPersistentStore __unused *persistentStore = [managedObjectStore addInMemoryPersistentStore:&error];
    NSAssert(persistentStore, @"Failed to add persistent store: %@", error);
    
    [managedObjectStore createManagedObjectContexts];
    
    // Set the default store shared instance
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    
    // Configure the object manager
    self.objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    self.objectManager.managedObjectStore = managedObjectStore;
    
    [RKObjectManager setSharedManager:self.objectManager];
    
    RKEntityMapping *personMapping = [RKEntityMapping mappingForEntityForName:@"Person" inManagedObjectStore:managedObjectStore];
    [personMapping addAttributeMappingsFromDictionary:[Person attributesKeyMap]];
    personMapping.identificationAttributes = [Person identificationAttributes];
    
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:personMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:kPersonsKeyPath
                                                keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
    
    
    [self.objectManager addResponseDescriptor:responseDescriptor];
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

- (void)loadPersonsSuccess:(void (^)(NSArray *persons))success failure:(void (^)(NSError *error))failure {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:kPersonsKeyPath
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  failure(error);
                                              }];
}


- (NSArray<Person*>*)fetchPersonsFromContext {
    
    NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    if  (!error)
        return fetchedObjects;
    
    return nil;
}


- (void)loadBalanceSuccess:(void (^)(NSArray *balances))success failure:(void (^)(NSError *error))failure {
    
}

#pragma mark - Core Data
- (NSManagedObjectContext *)managedObjectContext {
    return [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
}

@end
