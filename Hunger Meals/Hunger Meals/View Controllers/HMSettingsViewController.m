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
@interface HMSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;


@end

@implementation HMSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Settings";
    self.settingsTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    // Do any additional setup after loading the view.
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
        
        
    }else if(indexPath.row == 1){
        cell.SettingsRowLabel.text = @"Payments";
        cell.settingsImageView.image = [UIImage imageNamed:@"Payment_Card"];

    }//else if(indexPath.row == 2){
      //  cell.SettingsRowLabel.text = @"Offers";
      //  cell.settingsImageView.image = [UIImage imageNamed:@"Offers"];

 //   }
else if(indexPath.row == 2) {
        cell.SettingsRowLabel.text = @"Invite Friends";
        cell.settingsImageView.image = [UIImage imageNamed:@"Invite_Friends"];

    }else if(indexPath.row == 3) {
        cell.SettingsRowLabel.text = @"Help";
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
