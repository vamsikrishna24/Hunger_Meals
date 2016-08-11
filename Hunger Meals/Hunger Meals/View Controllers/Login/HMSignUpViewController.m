//
//  HMSignUpViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/07/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMSignUpViewController.h"

@interface HMSignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileNumber;
@property(strong,nonatomic) IBOutlet UIButton *verificationBtn;
@property(strong,nonatomic) IBOutlet UIView *otpView;
@property (weak, nonatomic) IBOutlet UITextField *otpTextField;
@property (weak, nonatomic) IBOutlet UIButton *resendOtpButton;
@property (weak, nonatomic) IBOutlet UIButton *otpStatusbutton;
@property (weak, nonatomic) IBOutlet UILabel *otpErrorLabel;

@end

@implementation HMSignUpViewController{
    MTGenericAlertView *oneTimePopUp;
    NSString *otpVerificationCode;
    BOOL isPopUpShowing;

}
- (IBAction)resendOtpButtonAction:(id)sender {
    [self mobileNumVerificationPressed:nil];
}
- (IBAction)verifyOtp:(id)sender {
    
    if([otpVerificationCode isEqualToString:self.otpTextField.text]){
       
        [oneTimePopUp close];
        [self.otpStatusbutton setTitle:@"Your Mobile number has been Verified" forState:UIControlStateNormal];
        self.otpErrorLabel.hidden = YES;
        self.otpStatusbutton.userInteractionEnabled = NO;

    }else{
        self.otpErrorLabel.hidden = NO;
        self.otpStatusbutton.userInteractionEnabled = YES;

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [Fonts fontHelveticaWithSize:19.0]
                                                            }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mobileNumVerificationPressed:(id)sender{
    
    if (!isPopUpShowing) {
        [self showPopUpBoxAtStartUp];
        isPopUpShowing = YES;
    }

    // Use your own details here

    NSString *twilioSID = @"ACe2d85301623c685816842946046a473e";
    NSString *twilioSecret = @"e3d3aa73f128852bea8a3eee1b4082f7";
    NSString *fromNumber = @"%2B16467834051";
    NSString *regionCode = @"%2B91";
    NSString *toNumber = [regionCode stringByAppendingString:self.mobileNumber.text];
    NSString *message = [self generateRandomNumber];
    
    otpVerificationCode = message;
    
    
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

-(void)showPopUpBoxAtStartUp{
    oneTimePopUp = [[MTGenericAlertView alloc] init];
    
    //Add close button only to handle close button action. Other wise by default close button will be added.
    oneTimePopUp.popUpCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [oneTimePopUp.popUpCloseButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [oneTimePopUp.popUpCloseButton addTarget:self action:@selector(closePopUp) forControlEvents:UIControlEventTouchUpInside];
    
    oneTimePopUp.isPopUpView = YES;
    [oneTimePopUp setCustomInputView:_otpView];
    [oneTimePopUp setDelegate:self];
    [oneTimePopUp show];
    
}

- (void)closePopUp{
    [oneTimePopUp close];
    isPopUpShowing = NO;
}

- (void)alertView:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //Do something here
}

- (IBAction)backCustom:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
