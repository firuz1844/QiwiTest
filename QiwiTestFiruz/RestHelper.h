//
//  RestHeper.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

/**
 RestHelper knows only about model-objets
 */

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@protocol RestHelperMappedObjectProtocol <NSObject>

@optional
+ (NSArray*)identificationAttributes;
@required
+ (NSDictionary*)attributesKeyMap;
@end


@class Person, Balance, ResponseObject;

@interface RestHelper : NSObject

- (void)loadPersons:(void (^)(ResponseObject *response, NSError *error))completion;
- (void)loadBalanceForPerson:(Person*)person completion:(void (^)(ResponseObject *response, NSError *error))completion;

#pragma mark - Core Data
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
