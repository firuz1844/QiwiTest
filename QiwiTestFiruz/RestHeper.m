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
#import "ResponseObject.h"

#import "NSArray+Mapper.h"

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
        [self setup];
    }
    return self;
}

- (void)setup {
    
    // Init manager
    self.objectManager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:kBaseUrl]];
    
    
    NSError *error = nil;
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    RKManagedObjectStore *managedObjectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:managedObjectModel];
    self.objectManager.managedObjectStore = managedObjectStore;
    
    // Initialize the Core Data stack
    [managedObjectStore createPersistentStoreCoordinator];
    
    // Persistent store on disk
    NSString *storePath = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"QiwiTestFiruz.sqlite"];
    NSString *seedPath = [[NSBundle mainBundle] pathForResource:@"QiwiTestFiruz" ofType:@"sqlite"];
    NSPersistentStore *persistentStoreDisk = [managedObjectStore addSQLitePersistentStoreAtPath:storePath fromSeedDatabaseAtPath:seedPath withConfiguration:@"Disk" options:nil error:&error];
    NSAssert(persistentStoreDisk, @"Failed to add persistent store: %@", error);
    
    // Persistent store in memory
    NSPersistentStore *persistentStoreMemory = [managedObjectStore.persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:@"Memory" URL:nil options:nil error:&error];
    NSAssert(persistentStoreMemory, @"Failed to add persistent store: %@", error);
    
    // Context
    [managedObjectStore createManagedObjectContexts];
    
    // Set the default store shared instance
    [RKManagedObjectStore setDefaultStore:managedObjectStore];
    
    
    // Mapping entities
    
    [RKObjectManager setSharedManager:self.objectManager];
    
    RKEntityMapping *personMapping = [RKEntityMapping mappingForEntityForName:@"Person" inManagedObjectStore:managedObjectStore];
    [personMapping addAttributeMappingsFromDictionary:[Person attributesKeyMap]];
    personMapping.identificationAttributes = [Person identificationAttributes];
    
    
    RKEntityMapping *balanceMapping = [RKEntityMapping mappingForEntityForName:@"Balance" inManagedObjectStore:managedObjectStore];
    [balanceMapping addAttributeMappingsFromDictionary:[Balance attributesKeyMap]];

    
    RKEntityMapping *responseMapping = [RKEntityMapping mappingForEntityForName:@"ResponseObject" inManagedObjectStore:managedObjectStore];
    [responseMapping addAttributeMappingsFromDictionary:[ResponseObject attributesKeyMap]];
    
    
    RKResponseDescriptor *descriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:personMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:nil
                                                keyPath:kPersonsKeyPath
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
    
    [self.objectManager addResponseDescriptor:descriptor];
    
    descriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:balanceMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:nil
                                                keyPath:kBalanceKeyPath
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
    
    
    [self.objectManager addResponseDescriptor:descriptor];
    
    descriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
    
    [self.objectManager addResponseDescriptor:descriptor];
    
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

- (void)loadPersons:(void (^)(ResponseObject *response, NSError *error))completion {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:kPersonsPath
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  completion([self responseFromMappingResult:mappingResult], nil);
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Failed loading persons %@", error);
                                                  completion(nil, error);
                                              }];
}

- (void)loadBalanceForPerson:(Person*)person completion:(void (^)(ResponseObject *response, NSError *error))completion {
    [[RKObjectManager sharedManager] getObjectsAtPath:[NSString stringWithFormat:kBalancePath, person.userId]
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  [[mappingResult array] mapWithBlock:^id(id model) {
                                                      if ([model isKindOfClass:[Balance class]]) {
                                                          [(Balance*)model setUserId:person.userId];
                                                      }
                                                      return model;
                                                  }];
                                                  completion([self responseFromMappingResult:mappingResult], nil);
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Error geting balances %@", error);
                                                  completion(nil, error);
                                              }];
    
}

- (ResponseObject*)responseFromMappingResult:(RKMappingResult*)result {
    ResponseObject *obj = [[[result array] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"class == %@ && self.code != 0", [ResponseObject class]]] firstObject];
    return obj;
}

- (NSManagedObjectContext *)managedObjectContext {
    return [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
}

@end
