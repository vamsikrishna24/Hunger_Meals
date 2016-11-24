//
//  SlideMenuViewController.m
//  Hunger Meals
//
//  Created by SivajeeBattina on 7/14/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "SlideMenuViewController.h"
#import "HMSlideMenuTableViewCell.h"
#import "HMOrdersListTableViewController.h"
#import "HMInviteViewController.h"
#import "HMUserProfileViewController.h"
#import "HMHomePageViewController.h"
#import "HMMonthlyDetailViewController.h"
#import "HMMealPlannerViewController.h"



@interface SlideMenuViewController (){

    NSMutableArray *slideMenuCategories;
    NSMutableArray *slideMenuimagesCategories;

}

@end

@implementation SlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    slideMenuCategories = [[NSMutableArray alloc] initWithObjects: @"Home",@"Meals", @"Monthly Meal Plan",@"Orders",@"Invite",@"User Profile",@"Sign Out", nil];
    slideMenuimagesCategories = [[NSMutableArray alloc] initWithObjects:@"Home", @"Meals", @"MonthlyPlanner",@"Orders",@"Invite_Friends",@"Account",@"Logout", nil];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.clipsToBounds = true;
    
    self.profileNameLabel.text = [UserData userName];
    self.emailLabel.text = [UserData email];
    self.phoneNumberLabel.text = [UserData phonNumber];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return slideMenuCategories.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"SlideMenuCellIdentifier";
    HMSlideMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HMSlideMenuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //UILabel *categoryLabel = (UILabel *)[cell viewWithTag:1];
    cell.menuLabel.text = slideMenuCategories[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:slideMenuimagesCategories[indexPath.row]] ;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if (indexPath.row == 0){
//        HMHomePageViewController *homeVC = [storyBoard instantiateViewControllerWithIdentifier:@"HomePage"];
//        [APPDELEGATE.homeNavigationController pushViewController:homeVC animated:YES];
        [self.revealViewController revealToggleAnimated:YES];
    }
    
    else if (indexPath.row == 1) {
        MealsViewController *mealsVC = [storyBoard instantiateViewControllerWithIdentifier:@"MealsViewIdentifier"];
        
        [APPDELEGATE.homeNavigationController pushViewController:mealsVC animated:YES];
        [self.revealViewController revealToggleAnimated:YES];

    }
    
    else if (indexPath.row == 2)
    {
        if ([[USER_DEFAULTS valueForKey: @"isGuestLogin"]  isEqual: @"YES"]){
            
            [BTAlertController showAlertWithMessage: @"Sign in with your account to explore all features in the app" andTitle: @"Sign in required" andOkButtonTitle: @"Ok" andCancelTitle:@"Cancel" andtarget:self andAlertCancelBlock:^{
                
            } andAlertOkBlock:^(NSString *userName) {
                
                [self guestAction];
            }];

        }else{

        [self navigateToMealPlan];
        }
    }
    else if (indexPath.row == 3){
        if ([[USER_DEFAULTS valueForKey: @"isGuestLogin"]  isEqual: @"YES"]){
            
            [BTAlertController showAlertWithMessage: @"Sign in with your account to explore all features in the app" andTitle: @"Sign in required" andOkButtonTitle: @"Ok" andCancelTitle:@"Cancel" andtarget:self andAlertCancelBlock:^{
                
            } andAlertOkBlock:^(NSString *userName) {
                [self guestAction];
                
            }];

        }else
        {
            
        HMOrdersListTableViewController *orderList = [storyBoard instantiateViewControllerWithIdentifier:@"OrdersViewIdentifier"];
        [APPDELEGATE.homeNavigationController pushViewController:orderList animated:YES];
        [self.revealViewController revealToggleAnimated:YES];
        }
    }
    if (indexPath.row == 4){
        
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        HMInviteViewController *inviteVC = [storyBoard instantiateViewControllerWithIdentifier:@"InviteFriendIdentifier"];
        //UINavigationController *senav = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationIdentifier"];
        //[self performSegueWithIdentifier:@"NavigationIdentifier" sender:nil];
        [self presentViewController:inviteVC animated:YES completion:nil];
    }
    if (indexPath.row == 5){
        
        if ([[USER_DEFAULTS valueForKey: @"isGuestLogin"]  isEqual: @"YES"]){
            
            [BTAlertController showAlertWithMessage: @"Sign in with your account to explore all features in the app" andTitle: @"Sign in required" andOkButtonTitle: @"Ok" andCancelTitle:@"Cancel" andtarget:self andAlertCancelBlock:^{
                
            } andAlertOkBlock:^(NSString *userName) {
                [self guestAction];
                
                }];

        }else{

        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        HMUserProfileViewController *profileVC = [storyBoard instantiateViewControllerWithIdentifier:@"UserProfileIdentifier"];

               [self presentViewController:profileVC animated:YES completion:nil];
        }
    }
    
    if (indexPath.row == 6) {
        
            [BTAlertController showAlertWithMessage: @"Are you sure want to Sign Out?" andTitle: @"Alert!" andOkButtonTitle: @"Ok" andCancelTitle:@"Cancel" andtarget:self andAlertCancelBlock:^{
                
            } andAlertOkBlock:^(NSString *userName) {
                [self guestAction];
            }];
            
        }
    
}

#pragma Mark - Custom Methods
-(void)navigateToMealPlan{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    SVService *service = [[SVService alloc] init];
    [service getcurrmealplanusingBlock:^(NSDictionary *resultDict) {
        if (resultDict.count > 0) {
            NSMutableArray *lunchList = [resultDict valueForKeyPath:@"data.lunchplandata.title"];
            NSMutableArray *dinnerList = [resultDict valueForKeyPath:@"data.dinnerplandata.title"];
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (lunchList.count || dinnerList.count) {
                HMMealPlannerViewController *monthlyMealViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MonthlyMealsViewIdentifier"];
                [APPDELEGATE.homeNavigationController pushViewController:monthlyMealViewController animated:YES];
            }
            else {
                HMMonthlyDetailViewController *monthlyMealViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MonthlyRecommondationViewIdentifier"];
                [APPDELEGATE.homeNavigationController pushViewController:monthlyMealViewController animated:YES];
            }
            
        }
        [self.revealViewController revealToggleAnimated:YES];
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}
-(void)guestAction{
    [[NSUserDefaults standardUserDefaults] setObject: nil forKey:@"UserData"];
    [[NSUserDefaults standardUserDefaults] setBool: NO forKey:@"isLoginValid"];
    [[NSUserDefaults standardUserDefaults] setValue: nil forKey: @"selectedLocation"];
    [[NSUserDefaults standardUserDefaults] setObject: @"NO" forKey: @"isLocationSelected"];
    [USER_DEFAULTS setObject: @"NO" forKey: @"isGuestLogin"];
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [[GIDSignIn sharedInstance] signOut];
    [APPDELEGATE showInitialScreen];
}
- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue { }

@end
