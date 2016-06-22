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

@interface DataHelper : NSObject

+ (instancetype)shared;

@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

- (void)getPersonsSuccess:(void (^)(NSArray *persons))success failure:(void (^)(NSError *error))failure;
- (void)getBalanceSuccess:(void (^)(NSArray *balances))success failure:(void (^)(NSError *error))failure;

@end
