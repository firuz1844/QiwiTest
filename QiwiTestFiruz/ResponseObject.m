//
//  ResponseError.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "ResponseObject.h"

@implementation ResponseObject

+ (NSDictionary *)attributesKeyMap {
    return @{@"result_code"  : @"resultCode",
             @"message"     : @"message"};
}

@end
