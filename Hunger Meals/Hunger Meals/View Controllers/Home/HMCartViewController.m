//
//  HMCartViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 25/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMCartViewController.h"
#import "HMCartTableViewCell.h"
#import "SVService.h"
#import "CartItem.h"

@interface HMCartViewController (){
    NSMutableArray *cartItemsArray;
}

@end

@implementation HMCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cart";
    self.cartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    [self fetchAndLoadData];
}

-(void)fetchAndLoadData{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    SVService *service = [[SVService alloc] init];
    [service getCartDatausingBlock:^(NSMutableArray *resultArray) {
        
        if (resultArray.count != 0 || resultArray != nil) {
            cartItemsArray = [resultArray copy];
        }
        
        [_cartTableView reloadData];
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [cartItemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cartCell = @"CartCellIdentifier";
    HMCartTableViewCell *cell = [self.cartTableView dequeueReusableCellWithIdentifier:cartCell];
    if (cell == nil) {
        cell = [[HMCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cartCell];
    }
    
    CartItem *cartObject = [cartItemsArray objectAtIndex:indexPath.row];
    
    cell.totalPriceLabel.text = cartObject.price;
    cell.cartItemTitle.text = cartObject.product.name;
    cell.countLabel.text = cartObject.quantity;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:cartObject.product.image_url]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
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

@end
