//
//  ResponseObject+CoreDataProperties.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 24.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ResponseObject+CoreDataProperties.h"

@implementation ResponseObject (CoreDataProperties)

@dynamic code;
@dynamic message;

+ (NSDictionary *)attributesKeyMap {
    return @{@"result_code"    : @"code",
             @"message" : @"message"};
}


@end
