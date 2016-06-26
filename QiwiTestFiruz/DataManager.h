//
//  DataManager.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RestHelper, FetchResultController;
@class PersonViewModel, BalanceViewModel, Person, ResponseObject;

@interface DataManager : NSObject

+ (instancetype)shared;

- (void)loadPersons:(void (^)(ResponseObject *response))completion;
- (void)loadBalanceForPerson:(Person*)person completion:(void (^)(ResponseObject *response))completion;


- (FetchResultController*)fetchedResultsControllerWithFetchRequest:(NSFetchRequest*)fetchRequest;
- (NSManagedObjectContext*)defaultContext;
@end
