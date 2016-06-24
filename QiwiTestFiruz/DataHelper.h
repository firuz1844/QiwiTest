//
//  DataHelper.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class RestHeper;
@class PersonViewModel, BalanceViewModel, Person, ResponseObject;

@interface DataHelper : NSObject

+ (instancetype)shared;

// Getting view models
- (void)updatePersons:(void (^)(ResponseObject *response))completion;
- (void)loadBalanceForPerson:(Person*)person completion:(void (^)(ResponseObject *response))completion;


- (NSFetchedResultsController*)fetchedResultsControllerWithFetchRequest:(NSFetchRequest*)fetchRequest;
- (NSManagedObjectContext*)defaultContext;
@end
