//
//  Balance+CoreDataProperties.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 24.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Balance.h"
#import "RestHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface Balance (CoreDataProperties) <RestHelperMappedObjectProtocol>

@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSString *currency;
@property (nullable, nonatomic, retain) NSNumber *userId;


@end

NS_ASSUME_NONNULL_END
