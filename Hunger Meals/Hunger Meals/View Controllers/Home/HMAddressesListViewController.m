//
//  HMAddressesListViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/11/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMAddressesListViewController.h"
#import "HMAddressesCell.h"
#import "SVService.h"
#import "HmDelieveriAddressViewController.h"


@implementation HMAddressesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Delivery Address";
    [self getLocations];
    self.addressesArray = [NSMutableArray new];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.addressesTableView.frame.size.width, 40)];
    
    UILabel *selectAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, headerView.frame.size.height/2-15,200, 15)];
    selectAddressLabel.text = @"Select Address";
    selectAddressLabel.textColor = APPLICATION_TITLE_COLOR;
    [headerView addSubview:selectAddressLabel];
    
    
    UIButton *addNewAddressButton = [[UIButton alloc]initWithFrame:CGRectMake(headerView.frame.size.width - 120, selectAddressLabel.frame.origin.y - 7.5, 100, 40)];
    [addNewAddressButton setTitle:@"ADD NEW" forState:UIControlStateNormal];
    [addNewAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headerView addSubview:addNewAddressButton];
    addNewAddressButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [addNewAddressButton setBackgroundColor:APPLICATION_COLOR];
    addNewAddressButton.layer.cornerRadius = 5;
    [addNewAddressButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Normal" size:13.0]];
    [addNewAddressButton addTarget:self action:@selector(proceedToCheckOut) forControlEvents:UIControlEventTouchUpInside];

    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.addressesTableView.frame.size.width, 40)];
    
    UIButton *proceedToCheckout = [[UIButton alloc]initWithFrame:CGRectMake(footerView.frame.size.width/2-125,headerView.frame.size.height/2-15,250,50)];
    [proceedToCheckout setTitle:@"Proceed to checkout" forState:UIControlStateNormal];
    [proceedToCheckout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    proceedToCheckout.layer.cornerRadius = 5;
    [proceedToCheckout setBackgroundColor:APPLICATION_COLOR];
    [footerView addSubview:proceedToCheckout];
    
    
    self.addressesTableView.tableHeaderView = headerView;
    self.addressesTableView.tableFooterView = footerView;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addressesArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AddressCellIdentifier";
    HMAddressesCell *cell = [self.addressesTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.addressLabel.textAlignment = NSTextAlignmentLeft;
    cell.addressLabel.textColor = APPLICATION_SUBTITLE_COLOR;
    cell.addressLabel.text = self.addressesArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
    }
}


- (void)getLocations {
    
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    SVService *service = [[SVService alloc] init];
    
    [service getLocationsDataUsingBlock:^(NSMutableArray *resultArray) {
        //[_instancesArray addObject: @{@"address":@"Banglore"}];
        if (resultArray != nil || resultArray.count != 0) {
            for(NSDictionary *addressDict in resultArray ){
                [self.addressesArray addObject:[addressDict valueForKeyPath:@"location.address"]];
            }
            
        }
        [self.addressesTableView reloadData];
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}
-(void)proceedToCheckOut{
   
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HmDelieveriAddressViewController *cartViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"deliverAddressIdentifier"];
    [self.navigationController pushViewController:cartViewController animated:YES];

    
}

@end
