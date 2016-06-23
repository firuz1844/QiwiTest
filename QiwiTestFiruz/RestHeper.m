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
#import "Balance.h"

static NSString * const kBaseUrl = @"https://w.qiwi.com";
static NSString * const kPersonsPath = @"/mobile/testtask/index.json";
static NSString * const kPersonsKeyPath = @"users";
static NSString * const kBalancePath = @"/mobile/testtask/users/:id/index.json";
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

    
//    RKEntityMapping *balanceMapping = [RKEntityMapping mappingForClass:[Balance class]];
//    [balanceMapping addAttributeMappingsFromDictionary:[Balance attributesKeyMap]];
//    
//    [personMapping addRelationshipMappingWithSourceKeyPath:@"balance" mapping:balanceMapping];

    RKResponseDescriptor *descriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:personMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:kPersonsPath
                                                keyPath:kPersonsKeyPath
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
    
    [self.objectManager addResponseDescriptor:descriptor];

    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

- (void)loadPersonsSuccess:(void (^)(NSArray *persons))success failure:(void (^)(NSError *error))failure {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:kPersonsPath
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  NSManagedObjectContext *context = [(RKManagedObjectRequestOperation *)operation managedObjectContext];
                                                  success([self fetchPersonsFromContextError:nil]);
                                                  [context save:nil];
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  failure(error);
                                              }];
}

- (void)loadBalanceForPerson:(Person*)person success:(void (^)(NSArray *balances))success failure:(void (^)(NSError *error))failure {
    [[RKObjectManager sharedManager] getObjectsAtPath:kBalancePath
                                           parameters:@{@"id" : person.id}
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  success([mappingResult array]);
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  failure(error);
                                              }];

}

- (NSArray<Person*>*)fetchPersonsFromContextError:(NSError**)error {
    
    NSManagedObjectContext *context = [RKManagedObjectStore defaultStore].mainQueueManagedObjectContext;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Person"];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:error];
    
    if  (!error)
        return fetchedObjects;
    
    return nil;
}

#pragma mark - Core Data
- (NSManagedObjectContext *)managedObjectContext {
    return [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
}

@end
