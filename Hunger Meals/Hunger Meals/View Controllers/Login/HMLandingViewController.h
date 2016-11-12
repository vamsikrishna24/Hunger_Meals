//
//  HMLandingViwecontroller.h
//  Hunger Meals
//
//  Created by Vamsi on 21/07/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>
#import "MBProgressHUD.h"

@interface HMLandingViewController :UIViewController <GIDSignInUIDelegate,GIDSignInDelegate, FBSDKLoginButtonDelegate, MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)signInButtonPressed:(id)sender;
@property (nonatomic) BOOL isSkip;

@end
