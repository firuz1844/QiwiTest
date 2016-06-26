//
//  PersonViewModel.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 22.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "PersonViewModel.h"
#import "Person.h"

@implementation PersonViewModel

- (instancetype)initWithPerson:(Person *)person {
    
    self = [super init];
    if (self) {
        _person = person;
        if (person.name.length > 0) {
            _nameText = [NSString stringWithFormat:@"%@", self.person.name];
        } else {
            _nameText = @"N/A";
        }
    }
    return self;
}

@end
