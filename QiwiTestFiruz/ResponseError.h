//
//  ResponseError.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestHeper.h"

@interface ResponseError : NSObject <RestHelperMappedObjectProtocol>

@property (nonatomic, assign) NSInteger resultCode;
@property (nonatomic, strong) NSString *message;

@end
