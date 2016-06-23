//
//  RestHeper.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@protocol RestHelperMappedObjectProtocol <NSObject>

@optional
+ (NSArray*)identificationAttributes;
@required
+ (NSDictionary*)attributesKeyMap;
@end


@class Person, Balance, ResponseObject;

@interface RestHeper : NSObject

// Getting models
- (void)loadPersonsSuccess:(void (^)(NSArray *persons))success failure:(void (^)(NSError *error))failure;
- (void)loadBalanceForPerson:(Person*)person success:(void (^)(NSArray *balances))success failure:(void (^)(NSError *error))failure;

- (NSArray<Person*>*)fetchPersonsFromContextError:(NSError**)error;

#pragma mark - Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
