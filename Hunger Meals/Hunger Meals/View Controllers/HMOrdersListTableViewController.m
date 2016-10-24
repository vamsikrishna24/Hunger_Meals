//
//  HMOrdersListTableViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 09/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMOrdersListTableViewController.h"
#import "HMOrdersListTableViewCell.h"
#import "HMOrderDetailTableViewController.h"
#import "SVService.h"
#import "OrderDetails.h"

@interface HMOrdersListTableViewController (){
    NSMutableArray *orderArray;
    NSArray *objectArray;
}

@end

@implementation HMOrdersListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ordersTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    orderArray = [[NSMutableArray alloc] init];

    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    SVService *service = [[SVService alloc] init];

    [service getCurrentActiveordersusingBlock:^(NSMutableArray *resultArray) {
        
        if (![resultArray isEqual:[NSNull null]]) {
            if(resultArray.count == 0){
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Orders" message:@"Currently there are no orders to deliver" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
            }
            orderArray = [resultArray copy];

        }


        [self.ordersTableView reloadData];

        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
        
    }];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(orderArray == 0){
        return 0;
    }
    return orderArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"OrdersCellIdentifier";
   HMOrdersListTableViewCell *cell = (HMOrdersListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[HMOrdersListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    OrderDetails *orderDetail = [orderArray objectAtIndex:indexPath.row];
    cell.orderTotalPrice.text = orderDetail.totalprice;
    cell.ItemNameLabel.text = [orderDetail.created_at objectForKey:@"date"];
    cell.orderDateLabel.text = [NSString stringWithFormat:@"Order ID: #%@", orderDetail.id];
    cell.viewDetailsButtonOutlet.tag = indexPath.row;
    
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HMOrderDetailTableViewController *orderDetailsVC = (HMOrderDetailTableViewController *)[segue destinationViewController];
    UIButton *viewDetailsBtn = (UIButton *)sender;
    orderDetailsVC.orderDetail = [orderArray objectAtIndex:viewDetailsBtn.tag];
}


- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)viewDetailsButtonAction:(id)sender {
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

//    HMOrderDetailTableViewController *orderDetailVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"OrderDetailIdentifier"];
//    [self.navigationController pushViewController:orderDetailVC animated:YES];

    
}
@end
