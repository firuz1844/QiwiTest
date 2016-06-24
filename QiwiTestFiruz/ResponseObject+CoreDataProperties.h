//
//  ResponseObject+CoreDataProperties.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 24.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ResponseObject.h"
#import "RestHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface ResponseObject (CoreDataProperties) <RestHelperMappedObjectProtocol>

@property (nullable, nonatomic, retain) NSNumber *code;
@property (nullable, nonatomic, retain) NSString *message;

@end

NS_ASSUME_NONNULL_END
