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
#import "HMPaymentTypeSelectionViewController.h"
#import "BTAlertController.h"



@implementation HMAddressesListViewController
{
    NSInteger selectedAddressRow;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Delivery Address";
    selectedAddressRow = -111;
    [self getLocations];
    self.addressesArray = [NSMutableArray new];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.addressesTableView.frame.size.width, 40)];
    
    UILabel *selectAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, headerView.frame.size.height/2-15,200, 15)];
    selectAddressLabel.text = @"Select Address";
    selectAddressLabel.textColor = APPLICATION_TITLE_COLOR;
    [headerView addSubview:selectAddressLabel];
    
    
    UIButton *addNewAddressButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 115, selectAddressLabel.frame.origin.y - 7.5, 100, 40)];
    [addNewAddressButton setTitle:@"ADD NEW" forState:UIControlStateNormal];
    [addNewAddressButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [headerView addSubview:addNewAddressButton];
    addNewAddressButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [addNewAddressButton setBackgroundColor:APPLICATION_COLOR];
    addNewAddressButton.layer.cornerRadius = 5;
    [addNewAddressButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Normal" size:13.0]];
    [addNewAddressButton addTarget:self action:@selector(addNewAddress) forControlEvents:UIControlEventTouchUpInside];

    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.addressesTableView.frame.size.width, 40)];
    
    UIButton *proceedToCheckout = [[UIButton alloc]initWithFrame:CGRectMake(footerView.frame.size.width/2-125,headerView.frame.size.height/2-15,250,50)];
    [proceedToCheckout setTitle:@"Proceed to checkout" forState:UIControlStateNormal];
    [proceedToCheckout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    proceedToCheckout.layer.cornerRadius = 5;
    [proceedToCheckout setBackgroundColor:APPLICATION_COLOR];
    [footerView addSubview:proceedToCheckout];
    [proceedToCheckout addTarget:self action:@selector(proceedToCheckOut) forControlEvents:UIControlEventTouchUpInside];
    

    
    self.addressesTableView.tableHeaderView = headerView;
    self.addressesTableView.tableFooterView = footerView;

}
- (void)showAlertWithMsg:(NSString *)msg{
    [BTAlertController showAlertWithMessage:msg andTitle:@"Hunger Meals" andOkButtonTitle:nil andCancelTitle:@"Ok" andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        
    }];
    
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
    HMAddressesCell *cell = (HMAddressesCell *)[self.addressesTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(selectedAddressRow == indexPath.row){
        cell.radioButtonImageView.image = [UIImage imageNamed:@"RadioOn"];
    }else{
        cell.radioButtonImageView.image = [UIImage imageNamed:@"RadioOff"];
    }
    
    cell.addressLabel.textAlignment = NSTextAlignmentLeft;
    cell.addressLabel.textColor = APPLICATION_SUBTITLE_COLOR;
    cell.addressLabel.text = self.addressesArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HMAddressesCell *addressCell = (HMAddressesCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    addressCell.radioButtonImageView.image = [UIImage imageNamed:@"RadioOn"];
    addressCell.isRadioButtonSelected = YES;
    selectedAddressRow = indexPath.row;
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    HMAddressesCell *addressCell = (HMAddressesCell *)[tableView cellForRowAtIndexPath:indexPath];

    addressCell.radioButtonImageView.image = [UIImage imageNamed:@"RadioOff"];
    addressCell.isRadioButtonSelected = NO;

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
-(void)addNewAddress{
   
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HmDelieveriAddressViewController *cartViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"deliverAddressIdentifier"];
    [self.navigationController pushViewController:cartViewController animated:YES];

    
}

-(void)proceedToCheckOut{
    if(selectedAddressRow == -111){
        
        [self showAlertWithMsg:@"Please choose your deliver address to proceed further"];
  
    }else {

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HMPaymentTypeSelectionViewController *paymentType = [mainStoryBoard instantiateViewControllerWithIdentifier:@"paymentTypeIdentifier"];
    paymentType.PaymentAmountString= self.priceString;
    [self.navigationController pushViewController:paymentType animated:YES];
    }
}

@end
