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
    [personMapping addAttributeMappingsFromDictionary:[Balance attributesKeyMap]];
    
    RKEntityMapping *responseMapping = [RKEntityMapping mappingForEntityForName:@"ResponseObject" inManagedObjectStore:managedObjectStore];
    [responseMapping addAttributeMappingsFromDictionary:[Balance attributesKeyMap]];
    
    
    RKResponseDescriptor *descriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:personMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:kPersonsPath
                                                keyPath:kPersonsKeyPath
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
    
    [self.objectManager addResponseDescriptor:descriptor];
    
    RKResponseDescriptor *descriptor1 =
    [RKResponseDescriptor responseDescriptorWithMapping:balanceMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:kBalancePath
                                                keyPath:kBalanceKeyPath
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
    
    
    [self.objectManager addResponseDescriptor:descriptor1];
    
    RKResponseDescriptor *descriptor2 =
    [RKResponseDescriptor responseDescriptorWithMapping:responseMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:nil
                                                keyPath:nil
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)
     ];
    
    [self.objectManager addResponseDescriptor:descriptor2];
    
    
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}

- (void)loadPersons:(void (^)(void))completion {
    
    [[RKObjectManager sharedManager] getObjectsAtPath:kPersonsPath
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  RKManagedObjectRequestOperation *moperation = (RKManagedObjectRequestOperation*)operation;
                                                  NSError *error;
                                                  [moperation.managedObjectContext saveToPersistentStore:&error];
                                                  if (error) {
                                                      NSLog(@"Error saving context %@", error);
                                                  }
                                                  completion();
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Failed loading persons %@", error);
                                                  completion();
                                              }];
}

- (void)loadBalanceForPerson:(Person*)person completion:(void (^)(void))completion {
    [[RKObjectManager sharedManager] getObjectsAtPath:[NSString stringWithFormat:kBalancePath, person.id]
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  completion();
                                              } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"Error geting balances %@", error);
                                                  completion();
                                              }];
    
}

- (NSManagedObjectContext *)managedObjectContext {
    return [RKObjectManager sharedManager].managedObjectStore.mainQueueManagedObjectContext;
}

@end
