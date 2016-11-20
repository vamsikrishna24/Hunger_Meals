//
//  HMUserProfileViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 16/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMUserProfileViewController.h"
#import "UserData.h"
#import "UserProfileAddressTableViewCell.h"
#import "SVService.h"



@interface HMUserProfileViewController (){
    MTGenericAlertView *locationPopup;

}
@property (weak, nonatomic) IBOutlet UITableView *profileAddressTableView;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;



@end

@implementation HMUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailLabel.text = [UserData email];
    self.emailLabel.font = [UIFont fontWithName:@"Helvetica-light" size:14];
    self.phoneNumberLabel.font = [UIFont fontWithName:@"Helvetica-light" size:14];
    [self getLocations];
    self.addressesArray = [NSMutableArray new];
    self.profileAddressTableView.layer.cornerRadius = 5;
    self.profileAddressTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addressesArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"UserProfileAddress";
    UserProfileAddressTableViewCell *cell = [self.profileAddressTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.profileAddressTextView.textAlignment = NSTextAlignmentLeft;
    
    cell.profileAddressTextView.text = self.addressesArray[indexPath.row];
    
    return cell;
}

- (void)getLocations {
    
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    SVService *service = [[SVService alloc] init];
    
    [service getLocationsDataUsingBlock:^(NSMutableArray *resultArray) {
        if (resultArray != nil || resultArray.count != 0) {
            for(NSDictionary *addressDict in resultArray ){
                [self.addressesArray addObject:[addressDict valueForKeyPath:@"location.address"]];
            }
            
        }
        [self.profileAddressTableView reloadData];
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}
- (void)syncLocationForUser:(NSString *)locationID{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: locationID, @"location_id", nil];
    SVService *service = [[SVService alloc] init];
    [service syncLocationToUserAccount:dict usingBlock:^(NSString *resultMessage) {
        
        if (resultMessage != nil || ![resultMessage isEqualToString:@""]) {
            NSLog(@"%@", resultMessage);
            [self.profileAddressTableView reloadData];
            
        }
        
    }];
    
}
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
