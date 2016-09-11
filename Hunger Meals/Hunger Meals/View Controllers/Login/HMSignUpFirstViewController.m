//
//  HMSignUpFirstViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 20/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMSignUpFirstViewController.h"
#import "HMOTPVerificationViewController.h"
#import "HMSignUpThirdViewController.h"

@interface HMSignUpFirstViewController (){
    HMOTPVerificationViewController *otpVerificationVC;
}

@end

@implementation HMSignUpFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *color = [UIColor colorWithRed:237.0f/255.0f green:140.0f/255.0f blue:37.0f/255.0f alpha:0.5];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    [self.emailTextField setValue:[UIFont fontWithName: @"American Typewriter Bold" size: 10] forKeyPath:@"_placeholderLabel.font"];
    self.paswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    self.phoneNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone number" attributes:@{NSForegroundColorAttributeName: color}];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.paswordTextField.frame.size.height - 1, self.paswordTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.paswordTextField.layer addSublayer:bottomBorder];
    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0.0f, self.paswordTextField.frame.size.height - 1, self.paswordTextField.frame.size.width, 1.0f);
    bottomBorder1.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;

    [self.emailTextField.layer addSublayer:bottomBorder1];
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.frame = CGRectMake(0.0f, self.paswordTextField.frame.size.height - 1, self.paswordTextField.frame.size.width, 1.0f);
    bottomBorder2.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;

    [self.phoneNumberTextField.layer addSublayer:bottomBorder2];

    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate methods
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 3) {
        [self checkAllTheFieldsFilledOrNot];
    }
}

- (void)checkAllTheFieldsFilledOrNot{
    if ([self.emailTextField.text isEqualToString:@""] || [self.paswordTextField.text isEqualToString:@""] || [self.phoneNumberTextField.text isEqualToString:@""]) {
        self.nextButtonOutlet.hidden = YES;
    }
    else{
        self.nextButtonOutlet.hidden = NO;
    }
}

- (IBAction)nextButtonAction:(id)sender {

    HMOTPVerificationViewController *SecondVC = [self.storyboard instantiateViewControllerWithIdentifier:@"secondPage"];
    self.pageIndex = 1;
    HMSignUpThirdViewController *thirdVC= [self.storyboard instantiateViewControllerWithIdentifier:@"thirdPage"];    
    [self.pageViewController setViewControllers:@[SecondVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
   
}
@end
