//
//  QuickbitesViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "CurriesViewController.h"
#import "MealsTableViewCell.h"
#import "SVService.h"
#import "Product.h"
#import "Inventory.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CurriesViewController (){
    MealsTableViewCell *cell;
    BOOL isCellExpanded;
    BOOL isVegSwitchOn;
    NSInteger quantity;

}

@property(nonatomic, strong) NSMutableArray *dishImagesArray;
@property (weak, nonatomic) IBOutlet UITableView *curriesTableView;
@property (strong, nonatomic) NSMutableArray *productObjectsArray;
@property (strong, nonatomic) NSArray *filteredProdcutsArray;



@end

@implementation CurriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _productObjectsArray = [[NSMutableArray alloc] init];
  //     [self fetchAndLoadData];
    
    
    // [self.quickBitesTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isCellExpanded = NO;
    [self fetchAndLoadData];

}

-(void)fetchAndLoadData{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: kToken,@"token",  nil];
    SVService *service = [[SVService alloc] init];
    [service getCurriesProductsDataUsingBlock:dict usingBlock:^(NSMutableArray *resultArray) {
        
        if (resultArray.count == 0 || resultArray == nil) {
            //[self displayMessageWhenNoData];
        }
        
        _productObjectsArray = [resultArray copy];
        [self.curriesTableView reloadData];
        
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isVegSwitchOn) {
        return _filteredProdcutsArray.count;
    }
    return _productObjectsArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MealsCellIdentifier";
    cell = (MealsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.addToCartButton.hidden = NO;
    cell.countLabel.text = @"1";
    cell.priceLabel.text = @"";
    cell.titleLabel.text = @"";
    cell.descriptionView.text = @"";
    cell.itemImageView.image = nil;
    if (cell == nil) {
        cell = [[MealsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    Product *product = _productObjectsArray[indexPath.row];
    if (isVegSwitchOn) {
        product = _filteredProdcutsArray[indexPath.row];
    }
    NSDictionary *inventory = [product.inventories firstObject];

    cell.addToCartButton.tag = indexPath.row;
    cell.incrementButton.tag = indexPath.row;
    cell.decrementButton.tag = indexPath.row;
    
    if([product.label  isEqual: @"veg"]){
     //   cell.vegNonVegColorView.backgroundColor = [UIColor greenColor];
        cell.vegImageView.image = [UIImage imageNamed:@"Veg"];

    }else if([product.label  isEqual: @"non-veg"]){
       // cell.vegNonVegColorView.backgroundColor = [UIColor redColor];
        cell.vegImageView.image = [UIImage imageNamed:@"NonVeg"];

        
    }
    NSInteger  qty = [product.quantity integerValue];
    
    if (qty > 0) {
        
        quantity = qty;
        cell.addToCartButton.hidden = YES;
        cell.countLabel.text = [NSString stringWithFormat:@"%ld",qty];
        
    }else{
        cell.addToCartButton.hidden = NO;
        
    }
    
    //  NSString *imageName = [NSString stringWithFormat:@"Dish_Images/%@.jpg",self.dishImagesArray[indexPath.row]];
    NSString *string = [NSString stringWithFormat:@"%@%@",imageAmazonlink,product.image_url];
    [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:string]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.titleLabel.text =product.name;
    cell.descriptionView.text = product.description;;
    
    if ([product.description isEqualToString: @""]) {
        cell.descriptionHeightConstraint.constant = 0;
    }
    else {
        CGSize newSize = [cell.descriptionView sizeThatFits:CGSizeMake(cell.descriptionView.frame.size.width, MAXFLOAT)];
        cell.descriptionHeightConstraint.constant = newSize.height;
    }

    cell.priceLabel.text = [NSString stringWithFormat:@"₹ %@",[inventory valueForKey: @"price"]];
    //[NSString stringWithFormat:@"Veg Manchurian  %ld",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    [tableView endUpdates];
    isCellExpanded = !isCellExpanded;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Product *product = [_productObjectsArray objectAtIndex:indexPath.row];
    CGFloat descHeight;
    if ([product.description isEqualToString: @""]) {
        descHeight = 0;
    }
    else {
        CGSize newSize = [cell.descriptionView sizeThatFits:CGSizeMake(cell.descriptionView.frame.size.width, MAXFLOAT)];
        descHeight = newSize.height;
    }
    return 375 + descHeight;

}

-(IBAction)vegFilterSwitchClicked:(id)sender{
    UISwitch *vegSwitch = (UISwitch *)sender;
    isVegSwitchOn = vegSwitch.isOn;
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.label == %@",@"veg"];
    self.filteredProdcutsArray = [self.productObjectsArray filteredArrayUsingPredicate:bPredicate];
    
    [_curriesTableView reloadData];
    
}

- (IBAction)addToCartAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    MealsTableViewCell *mealsCell = (MealsTableViewCell*)[_curriesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    Product *productObject = _productObjectsArray[btn.tag];
    NSInteger quantity = [mealsCell.countLabel.text intValue];

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: productObject.id, @"inventories_id",[NSNumber numberWithInteger:quantity], @"quantity",  nil];
    [Utility saveTocart:dict[@"inventories_id"] quantity:quantity];

    SVService *service = [[SVService alloc] init];
    [service addToCart:dict usingBlock:^(NSString *resultMessage) {
        if (resultMessage != nil) {
            
        }
        
        
    }];
    
    
}


@end
