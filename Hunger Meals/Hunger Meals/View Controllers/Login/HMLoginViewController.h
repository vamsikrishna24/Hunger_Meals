//
//  HMLoginViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 21/07/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Google/SignIn.h>

@interface HMLoginViewController : UIViewController<GIDSignInUIDelegate,GIDSignInDelegate, FBSDKLoginButtonDelegate>

@end
