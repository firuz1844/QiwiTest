//
//  AlertHelper.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 24.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "AlertHelper.h"
#import "ResponseObject.h"

@implementation AlertHelper

+ (UIAlertController*)alertControllerWith:(ResponseObject*)responseObject retryAction:(void(^)(void))retryAction {
    if (responseObject.code != 0) {
        
        NSString *message = [NSString stringWithFormat:@"%@: %@", responseObject.code, responseObject.message ?: @"Unexpected error"];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *retry = [UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (retryAction) retryAction();
            NSLog(@"Retry");
        }];
        
        
        [alertController addAction:cancel];
        [alertController addAction:retry];
        
        return alertController;

    }
    return nil;
}

@end
