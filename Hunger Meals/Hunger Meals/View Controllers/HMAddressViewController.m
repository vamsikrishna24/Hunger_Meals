//
//  HMAddressViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 07/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMAddressViewController.h"
#import "HMSettingsTableViewCell.h"
#import "HMAddressTableViewCell.h"

@interface HMAddressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@end

@implementation HMAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AddressViewController";
    HMAddressTableViewCell *cell = [self.settingsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.addressTableviewTextView.textAlignment = NSTextAlignmentCenter;
    
    if (cell == nil) {
        cell = [[HMAddressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
      
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
