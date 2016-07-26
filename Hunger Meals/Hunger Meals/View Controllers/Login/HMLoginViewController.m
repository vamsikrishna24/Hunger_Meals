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


@interface HMLoginViewController ()
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookLoginButton;
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property(strong,nonatomic) UIActivityIndicatorView *myActivityIndicator;

@end

@implementation HMLoginViewController{
    AppDelegate *appDelegate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    self.facebookLoginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    [self fetchUserInfo];
    
     [GIDSignIn sharedInstance].uiDelegate = self;
    
     [[GIDSignIn sharedInstance] signInSilently];
    
    

        // Do any additional setup after loading the view.
}


// read permissions
- (void)logInWithReadPermissions:(NSArray *)permissions
              fromViewController:(UIViewController *)fromViewController
                         handler:(FBSDKLoginManagerRequestTokenHandler)handler{
    if ([FBSDKAccessToken currentAccessToken]) {
        // TODO:Token is already available.
    }
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logInWithReadPermissions:@[@"email"]
                        fromViewController:self
                                   handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                       //TODO: process error or result
                                   }];

    
}

-(void)fetchUserInfo
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"results:%@",result);
                 
                 NSString *email = [result objectForKey:@"email"];
                 NSString *userId = [result objectForKey:@"id"];
                 
                 if (email.length >0 )
                 {
                     //Start you app Todo
                 }
                 else
                 {
                    // NSLog(@“Facebook email is not verified");
                           }
                           }
                           else
                           {
                               NSLog(@"Error %@",error);
                           }
                           }];
                           }
                           }
//publish Permissions
- (void)logInWithPublishPermissions:(NSArray *)permissions
                 fromViewController:(UIViewController *)fromViewController
                            handler:(FBSDKLoginManagerRequestTokenHandler)handler{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button

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
