//
//  AlertHelper.m
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 24.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import "AlertHelper.h"
#import "ResponseObject.h"
#import "Masonry.h"

@implementation AlertHelper

+ (UIAlertController*)alertControllerWith:(ResponseObject*)responseObject retryAction:(void(^)(void))retryAction {
    if (responseObject.code != 0) {
        
        NSString *message = [NSString stringWithFormat:@"%@: %@", responseObject.code, responseObject.message ?: @"N/A"];
        
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
+ (UIView*)viewWithIndicatorAddedToView:(UIView*)superview {
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel new];
    label.text = @"Loading...";
    label.textColor = [UIColor lightGrayColor];
    
    UIActivityIndicatorView *indicator = [UIActivityIndicatorView new];
    indicator.hidesWhenStopped = YES;
    [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    
    [view addSubview:label];
    [view addSubview:indicator];
    
    [superview addSubview:view];
    
    [superview bringSubviewToFront:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superview);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view.mas_centerY);
        make.centerX.equalTo(view.mas_centerX);
        make.leftMargin.equalTo(indicator.mas_right);
        make.centerY.equalTo(indicator.mas_centerY);
    }];
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
    
    return view;
}
@end
