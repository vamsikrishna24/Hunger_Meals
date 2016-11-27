//
//  HMSettingsViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 05/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMSettingsViewController.h"
#import "HMSettingsTableViewCell.h"
#import "HMAddressViewController.h"
#import "HMOrdersListTableViewController.h"
#import "HMInviteViewController.h"
#import "AppDelegate.h"
#import "UserData.h"
#import "HMAboutUsViewController.h"
#import "HMPaymentSuccessViewController.h"

@interface HMSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;


@end

@implementation HMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    self.settingsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    NSData *archiverData = [[NSUserDefaults standardUserDefaults]valueForKey:@"UserData"];
    
    UserData *userData = [NSKeyedUnarchiver unarchiveObjectWithData:archiverData];
    
    self.userEmailLabel.text = userData.email;
    self.userNameLabel.text = userData.name;
    self.userPhoneNumberLabel.text = userData.phone_no;

    // Do any additional setup after loading the view.
}
- (IBAction)logoutAction:(id)sender {
    
    [BTAlertController showAlertWithMessage: @"Are you sure want to Sign Out?" andTitle: @"Alert!" andOkButtonTitle: @"Ok" andCancelTitle:@"Cancel" andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        [[NSUserDefaults standardUserDefaults] setObject: nil forKey:@"UserData"];
        [[NSUserDefaults standardUserDefaults] setBool: NO forKey:@"isLoginValid"];
        [[NSUserDefaults standardUserDefaults] setValue: nil forKey: @"selectedLocation"];
        [[NSUserDefaults standardUserDefaults] setObject: @"NO" forKey: @"isLocationSelected"];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [[GIDSignIn sharedInstance] signOut];
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        HMLandingViewController *loginVC = (HMLandingViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"LandingPage"];
        
        [self presentViewController:loginVC animated:YES completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SettingsViewController";
    HMSettingsTableViewCell *cell = [self.settingsTableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
      cell = [[HMSettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    if(indexPath.row == 0){
        cell.SettingsRowLabel.text = @"Manage Addresses";
        cell.settingsImageView.image = [UIImage imageNamed:@"Home"];
        
        
//    }else if(indexPath.row == 1){
//        cell.SettingsRowLabel.text = @"Payments";
//        cell.settingsImageView.image = [UIImage imageNamed:@"Payment_Card"];
//
    }//else if(indexPath.row == 2){
      //  cell.SettingsRowLabel.text = @"Offers";
      //  cell.settingsImageView.image = [UIImage imageNamed:@"Offers"];

 //   }
    //   }
    else if(indexPath.row == 1) {
        cell.SettingsRowLabel.text = @"Orders";
        cell.settingsImageView.image = [UIImage imageNamed:@"Orders"];
    }
else if(indexPath.row == 2) {
        cell.SettingsRowLabel.text = @"Invite Friends";
        cell.settingsImageView.image = [UIImage imageNamed:@"Invite_Friends"];

    }else if(indexPath.row == 3) {
        cell.SettingsRowLabel.text = @"About Us";
        cell.settingsImageView.image = [UIImage imageNamed:@"Help"];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         HMAddressViewController *addressVC= [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddressViewController"];
        [self.navigationController pushViewController:addressVC animated:YES];
    }
    if (indexPath.row == 1) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HMOrdersListTableViewController *orderVC= [mainStoryBoard instantiateViewControllerWithIdentifier:@"OrdersViewIdentifier"];
        [self.navigationController pushViewController:orderVC animated:YES];    }
    if (indexPath.row == 2) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HMInviteViewController *inviteVC= [mainStoryBoard instantiateViewControllerWithIdentifier:@"InviteFriendIdentifier"];
        [self presentViewController:inviteVC animated:YES completion:nil];
    }
    if (indexPath.row == 3) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HMAboutUsViewController *aboutVC= [mainStoryBoard instantiateViewControllerWithIdentifier:@"AboutUsSidentifier"];
        [self presentViewController:aboutVC animated:YES completion:nil];
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
