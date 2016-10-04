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
@property (weak, nonatomic) IBOutlet UILabel *cartEmptyLabel;

@end

@implementation HMCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cartEmptyLabel.hidden = YES;
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

//- (IBAction)deleteCartItemAction:(id)sender{
//        [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
//    UIButton *btn = (UIButton *)sender;
//    CartItem *productObject = cartItemsArray[btn.tag];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: @"391", @"inventories_id",nil];
//
//        SVService *service = [[SVService alloc] init];
//        [service deleteCartItems:dict usingBlock:^(NSString *resultMessage) {
//            
//            
//            [_cartTableView reloadData];
//            [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
//        }];
//        
//    }


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (cartItemsArray.count == 0) {
        self.cartEmptyLabel.hidden = NO;
        
    }else {
        self.cartEmptyLabel.hidden = YES;
        
    }
    return [cartItemsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cartCell = @"CartCellIdentifier";
    HMCartTableViewCell *cell = [self.cartTableView dequeueReusableCellWithIdentifier:cartCell];
    if (cell == nil) {
        cell = [[HMCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cartCell];
    }
    
    CartItem *cartObject = [cartItemsArray objectAtIndex:indexPath.row];
    cell.incrementButton.tag = indexPath.row;
    cell.decrimentButton.tag = indexPath.row;
    cell.cancelButton.tag = indexPath.row;
    
    cell.totalPriceLabel.text = cartObject.price;
    cell.cartItemTitle.text = cartObject.product.name;
    cell.countLabel.text = cartObject.quantity;
    
    NSString *string = [NSString stringWithFormat:@"%@%@",imageAmazonlink,cartObject.product.image_url];
    [cell.cartItemsImageView sd_setImageWithURL:[NSURL URLWithString:string]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return cell;
    
}

- (IBAction)updateProductQuantiy:(id)sender{
    UIButton *btn = (UIButton *)sender;
    HMCartTableViewCell *mealsCell = (HMCartTableViewCell*)[_cartTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    Product *productObject = cartItemsArray[btn.tag];
    NSInteger quantity = [mealsCell.countLabel.text intValue];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: productObject.id, @"inventories_id",[NSNumber numberWithInteger:quantity], @"quantity",  nil];
    SVService *service = [[SVService alloc] init];
    [service addToCart:dict usingBlock:^(NSString *resultMessage) {
        if (resultMessage != nil) {
            
        }
        
        
    }];
    

}

- (IBAction)deleteCartItem:(id)sender{
    UIButton *btn = (UIButton *)sender;
    Product *productObject = cartItemsArray[btn.tag];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: productObject.id, @"inventories_id",0, @"quantity",  nil];
    SVService *service = [[SVService alloc] init];
    [service addToCart:dict usingBlock:^(NSString *resultMessage) {
        if (resultMessage != nil && [resultMessage isEqualToString:@"Cart has been updated"]) {
            [_cartTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        }
        
        
    }];
    

}

@end
