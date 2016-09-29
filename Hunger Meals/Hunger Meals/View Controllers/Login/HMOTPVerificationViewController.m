//
//  HMOTPVerificationViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 19/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMOTPVerificationViewController.h"
#import "HMSignUpPageViewController.h"
#import "HMSignUpThirdViewController.h"
#import "Utility.h"
#import "BTAlertController.h"
#import "SVService.h"
#import "HMSignUpFirstViewController.h"

@interface HMOTPVerificationViewController ()

@end

@implementation HMOTPVerificationViewController
{
    NSString *OTPCode;
    BOOL isMobileVerified;
    HMSignUpFirstViewController *firstVC;
    __block NSString *result;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetUp];
    [self generateAndSendOTPCode:nil];
    firstVC  = [[HMSignUpFirstViewController alloc]init];
}

- (void)initialSetUp{
    UIColor *color = [UIColor colorWithRed:237.0f/255.0f green:140.0f/255.0f blue:37.0f/255.0f alpha:0.5];
    self.otpTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter OTP Here" attributes:@{NSForegroundColorAttributeName: color}];
    [self.otpTextField setValue:[UIFont fontWithName: @"American Typewriter Bold" size: 10] forKeyPath:@"_placeholderLabel.font"];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.otpTextField.frame.size.height - 1, self.otpTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.otpTextField.layer addSublayer:bottomBorder];
    
    isMobileVerified = NO;
    
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    UISwipeGestureRecognizer* swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUpFrom:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
    [self.view addGestureRecognizer:swipeRightGestureRecognizer];

}

- (IBAction)verifyOtp:(id)sender {
//    
//    if([result isEqualToString:self.otpTextField.text]){
//        [self showAlertWithTitle:@"Success" andMessage:@"Congrats! Your mobile number has been verified."];
//        self.nextButtonOutlet.hidden = NO;
//        isMobileVerified = true;
//        
//    }else{
//        self.nextButtonOutlet.hidden = YES;
//        isMobileVerified = NO;
//    }
    [self verifyOtp];
    
}

- (IBAction) generateAndSendOTPCode:(id)sender{
//    if (OTPCode.length>0) {
//        [self sendVerificationCodeToMobile];
//    }
//    else {
//        OTPCode = [self generateRandomNumber];
//    }
    
    [self regenarateOtp];
}

-(void)regenarateOtp{
    
  //  [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.phoneNumber, @"phoneno",nil];

    SVService *service = [[SVService alloc] init];
    [service otpGenaration:dict usingBlock:^(NSString *resultMessage) {
        
        result = resultMessage;
        
          //[self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
        
    }];
    
}

-(void)verifyOtp{
    
    //  [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.phoneNumber,@"phoneno",self.otpTextField.text,@"otp",nil];
    
    SVService *service = [[SVService alloc] init];
    [service otpVerification:dict usingBlock:^(NSString *resultMessage) {
        
        result = resultMessage;
        
        //[self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
        
    }];
    
}
- (void)sendVerificationCodeToMobile{
    
    // Use your own details here
    
    NSString *twilioSID = @"ACe2d85301623c685816842946046a473e";
    NSString *twilioSecret = @"e3d3aa73f128852bea8a3eee1b4082f7";
    NSString *fromNumber = @"%2B16467834051";
    NSString *regionCode = @"%2B91";
    NSString *toNumber = [regionCode stringByAppendingString:self.phoneNumber];
    NSString *message = OTPCode;
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", twilioSID,twilioSecret,twilioSID];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"From=%@&To=%@&Body=%@", fromNumber, toNumber, message] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURLSessionTask *sessionTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //do somethign here
        if (error == nil && [(NSHTTPURLResponse *)response statusCode] == 201) {
            NSString* newStr = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
            NSLog(@"called successfully:%@",newStr);
            
        }
        else{
            NSString* error = [[NSString alloc] initWithData:data
                                                    encoding:NSUTF8StringEncoding];
            NSLog(@"End up with error:%@",error);
        }
    }];
    
    [sessionTask resume];
    
}

-(NSString *)generateRandomNumber{
    NSString *min =  @"100000"; //Get the current text from your minimum and maximum textfields.
    NSString *max = @"999999";
    
    int randNum = rand() % ([max intValue] - [min intValue]) + [min intValue]; //create the random number.
    
    NSString *num = [NSString stringWithFormat:@"%d", randNum]; //Make the number into a string.
    
    return num;
}


#pragma mark - TextField Delegate methods
- (void)textFieldDidEndEditing:(UITextField *)textField{
        [self isValidationsSucceed];
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
        NSString *resultText = [textField.text stringByReplacingCharactersInRange:range
                                                                       withString:string];
        if (resultText.length >= 6) {
            self.nextButtonOutlet.hidden = false;
        }
        else {self.nextButtonOutlet.hidden = true;}
        
        return resultText.length <= 6;
    
}

#pragma mark - Custom methods
- (BOOL)isValidationsSucceed{
    if(![Utility isValidateOTP:self.otpTextField.text]){
        [self showAlertWithTitle:@"Alert" andMessage:@"Please enter valid OTP!!"];
        return NO;
    }
    return YES;
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    [BTAlertController showAlertWithMessage:message andTitle:title andOkButtonTitle:nil andCancelTitle:@"Ok" andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        
    }];
    
}


- (IBAction)nextButtonAction:(id)sender {
    if ([self isValidationsSucceed] && isMobileVerified) {
        HMSignUpThirdViewController *thirdVC= [self.storyboard instantiateViewControllerWithIdentifier:@"thirdPage"];
        thirdVC.email = self.email;
        thirdVC.password = self.password;
        thirdVC.phoneNumber = self.phoneNumber;
        thirdVC.pageViewController = _pageViewController;
        [self.pageViewController setViewControllers:@[thirdVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
}

- (IBAction)previousButtonAction:(id)sender {
    
        [self.pageViewController setViewControllers:@[_signUpFirstVC] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
    
}

- (void)handleSwipeUpFrom:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self nextButtonAction:nil];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight){
        [self previousButtonAction:nil];
    }
}


@end
