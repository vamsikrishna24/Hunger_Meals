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
