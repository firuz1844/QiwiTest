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
@class PersonViewModel, BalanceViewModel, Person;

@interface DataHelper : NSObject

+ (instancetype)shared;

@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

// Getting view models
- (void)getPersonsSuccess:(void (^)(NSArray<PersonViewModel*> *persons))success failure:(void (^)(NSError *error))failure;
- (void)getBalanceForPerson:(Person*)person success:(void (^)(NSArray<BalanceViewModel*> *balances))success failure:(void (^)(NSError *error))failure;

@end
