//
//  HMTabBarViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMTabBarViewController.h"
#import "ProjectConstants.h"
#import "AppDelegate.h"
#import "HMConstants.h"
#import "HMCartViewController.h"

@interface HMTabBarViewController (){
AppDelegate *appDelegate;
}
@end

@implementation HMTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UITabBar appearance] setTintColor:APPLICATION_COLOR];
    [self setDelegate:self];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController

{
    NSUInteger indexOfTab = [tabBarController.viewControllers indexOfObject:viewController];
    NSLog(@"Tab index = %u (%u)", (int)indexOfTab);

    if ([[USER_DEFAULTS valueForKey: @"isGuestLogin"]  isEqual: @"YES"] && ((indexOfTab == 1) || (indexOfTab == 3)) ){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign in required" message:@"Sign in with your account to explore all features in the app" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        
        [alert show];
    }
    //    else if ([[USER_DEFAULTS valueForKey: @"isGuestLogin"]  isEqual: @"NO"]){
    //}
    }

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
    }else{
        [USER_DEFAULTS setObject: @"NO" forKey: @"isGuestLogin"];
        [[NSUserDefaults standardUserDefaults] setObject: nil forKey:@"UserData"];
        [[NSUserDefaults standardUserDefaults] setBool: NO forKey:@"isLoginValid"];
        [[NSUserDefaults standardUserDefaults] setValue: nil forKey: @"selectedLocation"];
        [[NSUserDefaults standardUserDefaults] setObject: @"NO" forKey: @"isLocationSelected"];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [[GIDSignIn sharedInstance] signOut];
        [APPDELEGATE showInitialScreen];

        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        HMLandingViewController *loginVC = (HMLandingViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"LandingPage"];
        
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
