//
//  NSArray+Mapper.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 23.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Mapper)

- (NSArray*)mapWithBlock:(id (^)(id model))blockName;

@end
