//
//  Person+CoreDataProperties.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

@dynamic id;
@dynamic name;

+ (NSDictionary *)attributesKeyMap {
    return @{@"id"      : @"id",
             @"name"    : @"name"};
}

+ (NSArray *)identificationAttributes {
    return @[@"id"];
}
@end
