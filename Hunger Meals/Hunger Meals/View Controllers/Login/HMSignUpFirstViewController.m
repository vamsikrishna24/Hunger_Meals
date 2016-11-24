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
#import "BTAlertController.h"
#import "Utility.h"
#import "SVService.h"

@interface HMSignUpFirstViewController (){
    HMOTPVerificationViewController *otpVerificationVC;
}

@end

@implementation HMSignUpFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIColor *color = [UIColor colorWithRed:119.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0];
    self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"User Name" attributes:@{NSForegroundColorAttributeName: color}];
    [self.userNameTextField setValue:[UIFont fontWithName: @"Roboto-Light" size: 13] forKeyPath:@"_placeholderLabel.font"];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
    [self.emailTextField setValue:[UIFont fontWithName: @"Roboto-Light" size: 13] forKeyPath:@"_placeholderLabel.font"];
    self.paswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    [self.paswordTextField setValue:[UIFont fontWithName: @"Roboto-Light" size: 13] forKeyPath:@"_placeholderLabel.font"];
    self.confirmPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: color}];
    [self.confirmPasswordTextField setValue:[UIFont fontWithName: @"Roboto-Light" size: 13] forKeyPath:@"_placeholderLabel.font"];
    self.phoneNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone number" attributes:@{NSForegroundColorAttributeName: color}];
    [self.phoneNumberTextField setValue:[UIFont fontWithName: @"Roboto-Light" size: 13] forKeyPath:@"_placeholderLabel.font"];

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
    
    CALayer *bottomBorder3 = [CALayer layer];
    bottomBorder3.frame = CGRectMake(0.0f, self.userNameTextField.frame.size.height - 1, self.userNameTextField.frame.size.width, 1.0f);
    bottomBorder3.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    
    [self.userNameTextField.layer addSublayer:bottomBorder3];
    
    CALayer *bottomBorder4 = [CALayer layer];
    bottomBorder4.frame = CGRectMake(0.0f, self.confirmPasswordTextField.frame.size.height - 1, self.confirmPasswordTextField.frame.size.width, 1.0f);
    bottomBorder4.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    
    [self.confirmPasswordTextField.layer addSublayer:bottomBorder4];

    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
     UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
    [self.view addGestureRecognizer:swipeRightGestureRecognizer];



    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextField Delegate methods
- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.tag == 3) {
//        [self isValidationsSucceed];
//    }
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
            replacementString:(NSString *)string {
    if (textField.tag == 3) {
        NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
                                                                    withString:string];
        if (resultText.length >= 10) {
            self.nextButtonOutlet.hidden = false;
        }
        else {self.nextButtonOutlet.hidden = true;}
        
        return true;

    }
   
    return true;
}

#pragma mark - Custom methods
- (BOOL)isValidationsSucceed{
    if(![Utility isUserNameValidation:self.userNameTextField.text]){
        [self showAlertWithTitle:@"Alert" andMessage:@"User name must be atleast 6 characters!!"];
        return NO;
    }
    else if(![Utility isValidateEmail:self.emailTextField.text]){
        [self showAlertWithTitle:@"Alert" andMessage:@"Please enter valid email!!"];
        return NO;
    }
    
    else if(![Utility isValidatePassword:self.paswordTextField.text]){
        [self showAlertWithTitle:@"Alert" andMessage:@"Password must be atleast 8 characters"];
        return NO;
    }
    else if(![self.paswordTextField.text isEqualToString: self.confirmPasswordTextField.text]){
        [self showAlertWithTitle:@"Alert" andMessage:@"Both password and confirm password should match,Please try again!!"];
        return NO;
    }
    else if([self.phoneNumberTextField.text  isEqual: @""]){
        [self showAlertWithTitle:@"Alert" andMessage:@"Please enter valid Phone Number and try again!!"];
        return NO;
    }
    self.nextButtonOutlet.hidden = false;
    return YES;
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    [BTAlertController showAlertWithMessage:message andTitle:title andOkButtonTitle:nil andCancelTitle:@"Ok" andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        
    }];
    
}


- (IBAction)nextButtonAction:(id)sender {
    if ([self isValidationsSucceed]) {
        HMOTPVerificationViewController *SecondVC = [self.storyboard instantiateViewControllerWithIdentifier:@"secondPage"];
        SecondVC.email = self.emailTextField.text;
        SecondVC.password = self.paswordTextField.text;
        SecondVC.phoneNumber = self.phoneNumberTextField.text;
        SecondVC.userName = self.userNameTextField.text;
        SecondVC.pageViewController = _pageViewController;
        SecondVC.signUpFirstVC = self;
        self.pageIndex = 1;
        
        [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.emailTextField.text, @"email",nil];
        SVService *service = [[SVService alloc] init];
        [service checkExistingUser:dict usingBlock:^(NSString *resultMessage) {
            
            [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
            if([resultMessage isEqualToString:@"You are already registered with us"]){
                
                return [[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"You are already registered with us" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }else{
                [self.pageViewController setViewControllers:@[SecondVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
            }

        }];



    }
}

- (IBAction)previousButtonAction:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    HMLandingViewController *loginVC = (HMLandingViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"LandingPage"];
    
    [self presentViewController:loginVC
                       animated:YES
                     completion:nil];
}


-(void)otpGenation{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.phoneNumberTextField.text, @"phoneno",nil];
    SVService *service = [[SVService alloc] init];
    [service otpGenaration:dict usingBlock:^(NSString *resultMessage) {
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
        
    }];

}

- (void)handleSwipeUpFrom:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self nextButtonAction:nil];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        [self previousButtonAction: nil];
    }
}


@end
