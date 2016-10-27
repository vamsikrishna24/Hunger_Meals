//
//  HMLoginViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 21/07/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMLandingViewController.h"
#import "AppDelegate.h"
#import "HMConstants.h"
#import "ProjectConstants.h"
#import "HMHomePageViewController.h"
#import "SVService.h"
#import "Utility.h"
#import "UserData.h"


@interface HMLandingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookLoginButton;
@property(weak, nonatomic) IBOutlet GIDSignInButton *googleSignInButton;
@property(strong,nonatomic) UIActivityIndicatorView *myActivityIndicator;
@property(strong,nonatomic) HMLandingViewController *homePageVC;
@property (nonatomic, strong) MBProgressHUD* hud;
@property (nonatomic, assign, getter=isIndicatorShowing) BOOL activityIndicatorIsShowing;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButtonOutlet;


@end

@implementation HMLandingViewController{
    AppDelegate *appDelegate;
}
@synthesize hud, activityIndicatorIsShowing;
- (void)viewDidLoad {
    [super viewDidLoad];
     [self setupFbConfiguration];
     [self initializations];
    
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
    
    [self.userNameTextField setValue:[UIFont fontWithName: @"Roboto-Light" size: 13] forKeyPath:@"_placeholderLabel.font"];
    [self.passwordTextField setValue:[UIFont fontWithName: @"Roboto-Light" size: 13] forKeyPath:@"_placeholderLabel.font"];
    
    UIColor *color = [UIColor colorWithRed:119.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0];
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
    self.facebookLoginButton.imageView.image = [UIImage imageNamed:@"Facebook"];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Google"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.googleSignInButton.backgroundColor = [UIColor colorWithPatternImage:image];

}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationItem.title = @"Hungry Meals";

    
}
-(void)setupFbConfiguration{
    
    self.facebookLoginButton.readPermissions = @[@"email"];
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
    
    if (result.token.tokenString == nil) {
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }else if (!error) {
        [self signUpWithFacebookDetails:result.token.tokenString];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserLogin"];
//        [APPDELEGATE showInitialScreen];
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
    
    if (user.authentication.accessToken) {
        [self signUpWithGoogleDetails:user.authentication.accessToken];
    }
    
    if ([GIDSignIn sharedInstance].currentUser.profile.hasImage)
    {
        // self.imageURL = [user.profile imageURLWithDimension:150];
    }
  
    
}

#pragma mark Custom Methods
- (void) signUpWithFacebookDetails:(NSString *)token{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: token, @"socialtoken", @"facebook", @"logintype",  nil];
    
    SVService *service = [[SVService alloc] init];
    [service signupWithSocialNetwork:dict usingBlock:^(NSMutableArray *resultArray) {

        if (resultArray.count != 0 || resultArray != nil) {
            UserData *dataObject = resultArray[0];
            NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dataObject];
            [[NSUserDefaults standardUserDefaults] setObject:personEncodedObject forKey:@"UserData"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoginValid"];
            [[NSUserDefaults standardUserDefaults] setObject: @"NO" forKey: @"isLocationSelected"];
            //([(AppDelegate *)[[UIApplication sharedApplication] delegate] enableCurrentLocation]);
            [APPDELEGATE showInitialScreen];
        }
        else {
            [self showAlertWithTitle:@"Oops!" andMessage:@"Error while sign up. Please try again later"];
        }
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];

}

- (void) signUpWithGoogleDetails:(NSString *)token{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: token, @"socialtoken", @"gmail", @"logintype",  nil];
    
    SVService *service = [[SVService alloc] init];
    [service signupWithSocialNetwork:dict usingBlock:^(NSMutableArray *resultArray) {
        
        if (resultArray.count != 0 || resultArray != nil) {
            UserData *dataObject = resultArray[0];
            NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dataObject];
            [[NSUserDefaults standardUserDefaults] setObject:personEncodedObject forKey:@"UserData"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoginValid"];
            [[NSUserDefaults standardUserDefaults] setObject: @"NO" forKey: @"isLocationSelected"];
            //([(AppDelegate *)[[UIApplication sharedApplication] delegate] enableCurrentLocation]);
            [APPDELEGATE showInitialScreen];
        }
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];

}

- (IBAction)signInButtonPressed:(id)sender{
    if ([self isValidationsSucceed]) {
            [self loginToServer];
        }
        else{
            [self showAlertWithTitle:@"You are offline!" andMessage:@"You are not connected to the internet. Please check your network connection and try again!!"];
        }
    
}

- (BOOL)isValidationsSucceed{
    if(![Utility isValidateEmail:self.userNameTextField.text] && ![Utility isValidatePassword:self.passwordTextField.text]){
        [self showAlertWithTitle:@"Check Credentials" andMessage:@"Error with credentials you have provied. Please check them and try again!!"];
        return NO;
    }
    else if(![Utility isValidateEmail:self.userNameTextField.text] ){
        [self showAlertWithTitle:@"Check Credentials" andMessage:@"Please enter valid email and try again!!"];
        return NO;
    }
    else if(![Utility isValidatePassword:self.passwordTextField.text]){
        [self showAlertWithTitle:@"Check Credentials" andMessage:@"Please enter valid password and try again!!"];
        return NO;
    }
    
    return YES;
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    [BTAlertController showAlertWithMessage:message andTitle:title andOkButtonTitle:nil andCancelTitle:@"Ok" andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        
    }];
    
}


# pragma userLoginAPI

- (void)loginToServer{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: _userNameTextField.text, @"email", _passwordTextField.text, @"password",  nil];
    
    SVService *service = [[SVService alloc] init];
    [service loginUserWithDict: dict usingBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count != 0 || resultArray != nil) {
            UserData *dataObject = resultArray[0];
            NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dataObject];
            [[NSUserDefaults standardUserDefaults] setObject:personEncodedObject forKey:@"UserData"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoginValid"];
            [[NSUserDefaults standardUserDefaults] setObject: @"NO" forKey: @"isLocationSelected"];
            //([(AppDelegate *)[[UIApplication sharedApplication] delegate] enableCurrentLocation]);
            [APPDELEGATE showInitialScreen];
        }
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}

#pragma -mark MBHUD ProgressView methods

- (void) initializations{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
}

- (void) showActivityIndicator: (NSString *) title {
    // The hud will disable all input on the view
    hud.opacity = 0.7f;
    
    if(title != nil) {
        hud.label.text = title;
    }
    
    // Add HUD to screen
    [self.view addSubview:hud];
    
    // Register for HUD callbacks so we can remove it from the window at the right time
    hud.delegate = self;
    [hud showAnimated:YES];
    [self setActivityIndicatorIsShowing:YES];
}

- (void) showActivityIndicatorWithTitle: (NSString *) title {
    
    //only ever show one HUD at a time
    if(!activityIndicatorIsShowing) {
        //Showing the activity indicator must be on the main thread.
        [self performSelectorOnMainThread:@selector(showActivityIndicator:) withObject:title waitUntilDone:NO];
    }
}

- (void) hideActivityIndicatorT {
    if(activityIndicatorIsShowing){
        [self hudWasHidden];
        [self setActivityIndicatorIsShowing:NO];
    }
}

- (void) hideActivityIndicator {
    //Hiding the activity indicator must be on the main thread.
    [self performSelectorOnMainThread:@selector(hideActivityIndicatorT) withObject:nil waitUntilDone:NO];
}

- (void) hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
}
- (IBAction)forgotPasswordButtonAction:(id)sender {
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];

     SVService *service = [[SVService alloc] init];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: _userNameTextField.text, @"email",  nil];
    [service forgotPassword:dict usingBlock:^(NSString *resultMessage) {
        
    [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];

    }];
}


@end
