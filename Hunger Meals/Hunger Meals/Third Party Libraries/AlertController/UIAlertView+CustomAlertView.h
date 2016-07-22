//
//  UIAlertView+MAAlertView.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 7/15/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (CustomAlertView)
- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;


@end
