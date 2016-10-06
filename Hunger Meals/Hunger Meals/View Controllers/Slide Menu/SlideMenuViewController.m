//
//  SlideMenuViewController.m
//  Hunger Meals
//
//  Created by SivajeeBattina on 7/14/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "SlideMenuViewController.h"
#import "HMSlideMenuTableViewCell.h"

@interface SlideMenuViewController (){

    NSMutableArray *slideMenuCategories;
    NSMutableArray *slideMenuimagesCategories;

}

@end

@implementation SlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    slideMenuCategories = [[NSMutableArray alloc] initWithObjects: @"Meals", @"Monthly Plan",@"Shop",@"Orders",@"Invite",@"Help",@"Sign Out", nil];
    slideMenuimagesCategories = [[NSMutableArray alloc] initWithObjects: @"Meals", @"Meals",@"Meals",@"Meals",@"Meals",@"Meals",@"Meals", nil];
    
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
    
    if (indexPath.row == 6) {
        
            [BTAlertController showAlertWithMessage: @"Are you sure want to Sign Out?" andTitle: @"Alert!" andOkButtonTitle: @"Ok" andCancelTitle:@"Cancel" andtarget:self andAlertCancelBlock:^{
                
            } andAlertOkBlock:^(NSString *userName) {
                [[NSUserDefaults standardUserDefaults] setObject: nil forKey:@"UserData"];
                [[NSUserDefaults standardUserDefaults] setBool: NO forKey:@"isLoginValid"];
                [[NSUserDefaults standardUserDefaults] setValue: nil forKey: @"selectedLocation"];
                [[NSUserDefaults standardUserDefaults] setObject: @"NO" forKey: @"isLocationSelected"];
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                HMLandingViewController *loginVC = (HMLandingViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"LandingPage"];
                
                [self presentViewController:loginVC
                                   animated:YES
                                 completion:nil];
            }];
            
        }
    
}

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue { }

@end
