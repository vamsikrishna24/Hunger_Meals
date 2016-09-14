//
//  HMLoginViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 21/07/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMLandingViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKLoginManager.h>
#import "AppDelegate.h"
#import "HMConstants.h"
#import "ProjectConstants.h"
#import "HMHomePageViewController.h"
#import "SVService.h"


@interface HMLandingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookLoginButton;
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property(strong,nonatomic) UIActivityIndicatorView *myActivityIndicator;
@property(strong,nonatomic) HMLandingViewController *homePageVC;


@end

@implementation HMLandingViewController{
    AppDelegate *appDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setupFbConfiguration];
    
     [GIDSignIn sharedInstance].uiDelegate = self;
     [[GIDSignIn sharedInstance] signInSilently];
     [GIDSignIn sharedInstance].delegate = self;
    self.logoImageView.layer.cornerRadius = 10;
    self.logoImageView.layer.borderWidth = 10;
    self.logoImageView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor whiteColor]);
    self.logoImageView.layer.shadowColor = (__bridge CGColorRef _Nullable)([UIColor darkGrayColor]);
    self.logoImageView.clipsToBounds = true;
    
    CGRect frameRect = self.userNameTextField.frame;
    frameRect.size.height = 40; // <-- Specify the height you want here.
    self.userNameTextField.frame = frameRect;
    self.passwordTextField.frame = frameRect;
    
    UIColor *color = [UIColor colorWithRed:237.0f/255.0f green:140.0f/255.0f blue:37.0f/255.0f alpha:0.5];
    self.userNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Id" attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.userNameTextField.frame.size.height - 1, self.userNameTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.userNameTextField.layer addSublayer:bottomBorder];

    CALayer *bottomBorder1 = [CALayer layer];
    bottomBorder1.frame = CGRectMake(0.0f, self.passwordTextField.frame.size.height - 1, self.passwordTextField.frame.size.width, 1.0f);
    bottomBorder1.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.passwordTextField.layer addSublayer:bottomBorder1];



}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationItem.title = @"Hungry Meals";

    
}
-(void)setupFbConfiguration{
    
    self.facebookLoginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.facebookLoginButton.delegate = self;
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(profileUpdated:) name:FBSDKProfileDidChangeNotification object:nil];
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         
         if (!error) {
             NSLog(@"fetched user:%@  and Email : %@", result,result[@"email"]);
             [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserLogin"];
             
         }
     }];

}

-(void)profileUpdated:(NSNotification *) notification{
    NSLog(@"User name: %@",[FBSDKProfile currentProfile].name);
    NSLog(@"User ID: %@",[FBSDKProfile currentProfile].userID);
}

- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    
    if (!error) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserLogin"];
        [APPDELEGATE showInitialScreen];
    }
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

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    
    if ([GIDSignIn sharedInstance].currentUser.profile.hasImage)
    {
        // self.imageURL = [user.profile imageURLWithDimension:150];
    }
  
    
}

- (IBAction)signInButtonPressed:(id)sender{
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserLogin"];
    //[APPDELEGATE showInitialScreen];
    [self fetchAndLoadData];
}

# pragma userLoginAPI

-(void)fetchAndLoadData{
    //[self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: _userNameTextField.text, @"userName", _passwordTextField.text, @"password",  nil];
    SVService *service = [[SVService alloc] init];
    [service loginUserWithDict: dict usingBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count == 0 || resultArray == nil) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserLogin"];
            [APPDELEGATE showInitialScreen];
        }
       // [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}
@end
