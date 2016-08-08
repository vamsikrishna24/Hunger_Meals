//
//  HMLoginViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 21/07/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMLoginViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKLoginManager.h>
#import "AppDelegate.h"
#import "HMHomePageViewController.h"


@interface HMLoginViewController ()
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookLoginButton;
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property(strong,nonatomic) UIActivityIndicatorView *myActivityIndicator;
@property(strong,nonatomic) HMHomePageViewController *homePageVC;


@end

@implementation HMLoginViewController{
    AppDelegate *appDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self setupFbConfiguration];
    
     [GIDSignIn sharedInstance].uiDelegate = self;
     [[GIDSignIn sharedInstance] signInSilently];

}

-(void)setupFbConfiguration{
    
    self.facebookLoginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.facebookLoginButton.delegate = self;
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileUpdated:) name:FBSDKProfileDidChangeNotification object:nil];
    
}

-(void)profileUpdated:(NSNotification *) notification{
    NSLog(@"User name: %@",[FBSDKProfile currentProfile].name);
    NSLog(@"User ID: %@",[FBSDKProfile currentProfile].userID);
}

- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    
        
        
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}


#pragma mark - Google Sign-In Delegate Methods
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    [self.myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Google SignOut
- (IBAction)didTapSignOut:(id)sender {
    [[GIDSignIn sharedInstance] signOut];
}




@end
