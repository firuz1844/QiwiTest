//
//  FetchResultController.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 26.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "FetchResultController.h"
#import "PersonViewModel.h"
#import "Person.h"
#import "BalanceViewModel.h"
#import "Balance.h"

#import "NSArray+Mapper.h"
@implementation FetchResultController

- (id)viewModelAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self objectAtIndexPath:indexPath];
    
    if ([object isKindOfClass:[Person class]]) {
        return [[PersonViewModel alloc] initWithPerson:object];
    }
    if ([object isKindOfClass:[Balance class]]) {
        return [[BalanceViewModel alloc] initWithBalance:object];
    }
    return nil;
}

- (NSArray *)fetchedViewModels {
    NSArray *objects = [super fetchedObjects];
    if ([[objects firstObject] isKindOfClass:[Person class]]) {
        return [self personViewModelsWithArray:objects];
    }
    if ([[objects firstObject] isKindOfClass:[Balance class]]) {
        return [self balanceViewModelsWithArray:objects];
    }
    return nil;
}

- (NSArray*)personViewModelsWithArray:(NSArray*)array {
    NSArray *viewModels = [array mapWithBlock:^id(id object) {
        if ([object isKindOfClass:[Person class]]) {
            PersonViewModel *viewModel = [[PersonViewModel alloc] initWithPerson:object];
            return viewModel;
        }
        NSAssert([object isKindOfClass:[Person class]], @"Unexpected model class");
        return object;
    }];
    return viewModels;
}

- (NSArray*)balanceViewModelsWithArray:(NSArray*)array {
    NSArray *viewModels = [array mapWithBlock:^id(id object) {
        if ([object isKindOfClass:[Balance class]]) {
            BalanceViewModel *viewModel = [[BalanceViewModel alloc] initWithBalance:object];
            return viewModel;
        }
        NSAssert([object isKindOfClass:[Balance class]], @"Unexpected model class");
        return object;
    }];
    return viewModels;
}

@end
