//
//  HMOrderDetailTableViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 10/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMOrderDetailTableViewController.h"
#import "Product.h"
#import "Tax.h"

@interface HMOrderDetailTableViewController (){
    NSMutableArray *orderTitlesArray;
    NSMutableArray *orderPriceArray;
}

@end

@implementation HMOrderDetailTableViewController
@synthesize orderDetail;

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"Order Details";
    orderTitlesArray = [[NSMutableArray alloc] init];
    orderPriceArray = [[NSMutableArray alloc] init];
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"Order ID: #%@", orderDetail.id];
    NSDictionary *timeDict = orderDetail.created_at;
    self.orderDateLabel.text = [timeDict valueForKey:@"date"];
    
    [self preparingTableViewData];
    
}

- (void) preparingTableViewData{
    for (CartItem *cartObj in orderDetail.cartItems) {
        NSDictionary *dict = [cartObj valueForKey:@"product"];
        [orderTitlesArray addObject:[NSString stringWithFormat:@"%@(%@)", [dict valueForKey:@"name"], [cartObj valueForKey:@"quantity"]]];
        float price = [orderDetail.totalprice floatValue];
        float quantity = [[cartObj valueForKey:@"quantity"] floatValue];
        [orderPriceArray addObject:[NSString stringWithFormat:@"%.2f ₹",price/quantity]];
    }
    
    [orderTitlesArray addObject:@"Item Total"];
    float totalPrice = [orderDetail.totalprice floatValue];
    [orderPriceArray addObject:[NSString stringWithFormat:@"%.2f ₹",totalPrice]];
    [self addTaxDetails];
    
    [_orderDetailsTableview reloadData];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return orderTitlesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderDetailsCellIdentifier" forIndexPath:indexPath];
    
    UILabel *titleLable = [cell viewWithTag:1];
    titleLable.text = [orderTitlesArray objectAtIndex:indexPath.row];
    
    UILabel *priceLable = [cell viewWithTag:2];
    priceLable.text = [orderPriceArray objectAtIndex:indexPath.row];

    
    return cell;
}

-(void)addTaxDetails{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Tax" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSMutableDictionary *taxDict = [[NSMutableDictionary alloc]init];
    taxDict = [json valueForKey:@"tax"];
    float value1 = 0.0;
    int total = [[orderDetail valueForKey:@"totalprice"] floatValue];
    
    value1 = [[taxDict objectForKey:@"service_charge"] floatValue];
    value1 = (value1*total)/100;
    [orderTitlesArray addObject:@"Service Charge"];
    [orderPriceArray addObject:[NSString stringWithFormat:@"%.2f ₹",value1]];
    
    value1 = [[taxDict objectForKey:@"service_tax"] floatValue];
    value1 = (value1*total)/100;
    [orderTitlesArray addObject:@"Service Tax"];
    [orderPriceArray addObject:[NSString stringWithFormat:@"%.2f ₹",value1]];
    
    value1 = [[taxDict objectForKey:@"VAT"] floatValue];
    value1 = (value1*total)/100;
    [orderTitlesArray addObject:@"VAT"];
    [orderPriceArray addObject:[NSString stringWithFormat:@"%.2f ₹",value1]];
    
    value1 = [[taxDict objectForKey:@"CESS"] floatValue];
    value1 = (value1*total)/100;
    [orderTitlesArray addObject:@"CESS"];
    [orderPriceArray addObject:[NSString stringWithFormat:@"%.2f ₹",value1]];
    
    value1 = [[taxDict objectForKey:@"delivery_charge"] floatValue];
    value1 = (value1*total)/100;
    [orderTitlesArray addObject:@"Delivery Charge"];
    [orderPriceArray addObject:[NSString stringWithFormat:@"%.2f ₹",value1]];
    
    value1 = [[taxDict objectForKey:@"packing_charge"] floatValue];
    value1 = (value1*total)/100;
    [orderTitlesArray addObject:@"Packaging Charge"];
    [orderPriceArray addObject:[NSString stringWithFormat:@"%.2f ₹",value1]];

    value1 = [[taxDict objectForKey:@"delivery_charge"] floatValue];
    value1 = (value1*total)/100;
    [orderTitlesArray addObject:@"Delivery Free"];
    if (value1 > 0) {
        [orderPriceArray addObject:@"NO"];
    }
    else {
        [orderPriceArray addObject:@"YES"];
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
