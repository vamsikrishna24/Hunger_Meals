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
    
    objectArray= [orderArray valueForKey:@"totalprice"];
    cell.orderTotalPrice.text = [NSString stringWithFormat:@"%@",objectArray[indexPath.row]];
    objectArray= [orderArray valueForKeyPath:@"cartItems.product.name"];
    
    NSMutableString *productNameString = [[NSMutableString alloc]init];
    NSArray *nameArray = [objectArray objectAtIndex:indexPath.row];
    
        for (NSString *nameString in nameArray) {
            
            [productNameString appendFormat:@"%@,",nameString];
        
    }
    cell.ItemNameLabel.text = productNameString;

    objectArray= [orderArray valueForKeyPath:@"created_at.date"];

    cell.orderDateLabel.text = [NSString stringWithFormat:@"%@",objectArray[indexPath.row]];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)viewDetailsButtonAction:(id)sender {
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

//    HMOrderDetailTableViewController *orderDetailVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"OrderDetailIdentifier"];
//    [self.navigationController pushViewController:orderDetailVC animated:YES];

    
}
@end
