//
//  ResponseError.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "ResponseError.h"

@implementation ResponseError

+ (NSDictionary *)attributesKeyMap {
    return @{@"resultCode"  : @"result_code",
             @"message"     : @"message"};
}

@end
