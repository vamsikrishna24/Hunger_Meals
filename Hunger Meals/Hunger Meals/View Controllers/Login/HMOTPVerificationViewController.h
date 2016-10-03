//
//  HMOTPVerificationViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 19/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSignUpFirstViewController.h"
#import "CommonViewController.h"

@interface HMOTPVerificationViewController : CommonViewController
@property NSUInteger pageIndex;
@property NSString *email;
@property NSString *password;
@property NSString *phoneNumber;
@property NSString *userName;
@property(strong,nonatomic) UIPageViewController *pageViewController;
@property(strong,nonatomic) HMSignUpFirstViewController *signUpFirstVC;


@property (weak, nonatomic) IBOutlet UITextField *otpTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *prevButtonOutlet;

- (IBAction)nextButtonAction:(id)sender;
- (IBAction)previousButtonAction:(id)sender;
@end
