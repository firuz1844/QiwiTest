//
//  NSArray+Mapper.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 23.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "NSArray+Mapper.h"

@implementation NSArray (Mapper)

- (NSArray*)mapWithBlock:(id (^)(id model))transform {
    NSMutableArray *newArray = [NSMutableArray new];
    for (id object in self) {
        [newArray addObject:transform(object)];
    }
    return [newArray copy];
}

@end
