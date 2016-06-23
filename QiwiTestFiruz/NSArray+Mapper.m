//
//  NSArray+Mapper.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 23.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "NSArray+Mapper.h"

@implementation NSArray (Mapper)

- (NSArray*)mapWithBlock:(id (^)(id model))blockName {
    NSMutableArray *newArray = [NSMutableArray new];
    for (id model in self) {
        [newArray addObject:blockName(model)];
    }
    return [newArray copy];
}

@end
