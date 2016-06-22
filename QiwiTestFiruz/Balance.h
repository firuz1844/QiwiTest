//
//  Balance.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestHeper.h"

@interface Balance : NSObject <RestHelperMappedObjectProtocol>

@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSNumber *amount;
@end
