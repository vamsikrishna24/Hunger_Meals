//
//  HMPaymentSuccessViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 23/11/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMPaymentSuccessViewController.h"
#import "ProjectConstants.h"

@implementation HMPaymentSuccessViewController

- (IBAction)closeAction:(id)sender {
    [APPDELEGATE.homeNavigationController popToRootViewControllerAnimated:YES];
}
@end
