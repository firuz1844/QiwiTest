//
//  AlertHelper.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 24.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@class ResponseObject;

@interface AlertHelper : NSObject

+ (UIAlertController*)alertControllerWith:(ResponseObject*)responseObject retryAction:(void(^)(void))retryAction;
+ (UIView*)viewWithIndicatorAddedToView:(UIView*)superview;
@end
