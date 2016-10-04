//
//  SouthIndianViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "SouthIndianViewController.h"
#import "MealsTableViewCell.h"
#import "SVService.h"
#import "Product.h"
#import "Inventory.h"


@interface SouthIndianViewController (){
    BOOL isCellExpanded;
    NSInteger tableViewHeight;
    BOOL isVegSwitchOn;

}

@property(nonatomic, strong) NSMutableArray *dishImagesArray;

@property (weak, nonatomic) IBOutlet UITableView *southIndianTableView;
@property (strong, nonatomic) NSMutableArray *productObjectsArray;
@property (strong, nonatomic) NSArray *filteredProdcutsArray;



@end

@implementation SouthIndianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dishImagesArray = [[NSMutableArray alloc]initWithObjects:@"dish1",@"dish2",@"dish3",@"dish4",@"dish5",@"dish6",@"dish7",@"dish8",@"dish9",@"dish10",@"dish11",@"dish12",@"dish13",@"dish14",@"dish15",@"dish16", nil];
    [self fetchAndLoadData];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isCellExpanded = NO;
    tableViewHeight = 210;
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
    MealsTableViewCell *cell = (MealsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
    
    if([product.label  isEqual: @"veg"]){
        cell.vegNonVegColorView.backgroundColor = [UIColor greenColor];
    }else if([product.label  isEqual: @"non-veg"]){
        cell.vegNonVegColorView.backgroundColor = [UIColor redColor];
        
    }

    Inventory *inventory = product.inventories[0];
    
    cell.addToCartButton.tag = indexPath.row;
    cell.incrementButton.tag = indexPath.row;
    cell.decrementButton.tag = indexPath.row;

//    NSString *imageName = [NSString stringWithFormat:@"Dish_Images/%@.jpg",self.dishImagesArray[indexPath.row]];
//    cell.itemImageView.image = [UIImage imageNamed:imageName];
    NSString *string = [NSString stringWithFormat:@"%@%@",imageAmazonlink,product.image_url];
    [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:string]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.titleLabel.text = product.name;
    cell.descriptionView.text = product.description;
    cell.priceLabel.text = [inventory valueForKey:@"price"];
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
    NSIndexPath *selectedIndexPath  = [tableView indexPathForSelectedRow];
    
    if ([indexPath isEqual:selectedIndexPath] && !isCellExpanded) {
        return 440;
    }
    return 345;
}
-(void)fetchAndLoadData{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: kToken,@"token",  nil];
    SVService *service = [[SVService alloc] init];
    [service getSouthIndianProductsDataUsingBlock:dict usingBlock:^(NSMutableArray *resultArray) {
        
        if (resultArray.count == 0 || resultArray == nil) {
            //[self displayMessageWhenNoData];
        }
        _productObjectsArray = [resultArray copy];
        [self.southIndianTableView reloadData];

        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
}

-(IBAction)vegFilterSwitchClicked:(id)sender{
    UISwitch *vegSwitch = (UISwitch *)sender;
    isVegSwitchOn = vegSwitch.isOn;
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.label == %@",@"veg"];
    self.filteredProdcutsArray = [self.productObjectsArray filteredArrayUsingPredicate:bPredicate];
    
    [_southIndianTableView reloadData];
    
}

- (IBAction)addToCartAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    MealsTableViewCell *mealsCell = (MealsTableViewCell*)[_southIndianTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    Product *productObject = _productObjectsArray[btn.tag];
    NSInteger quantity = [mealsCell.countLabel.text intValue];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: productObject.id, @"inventories_id",[NSNumber numberWithInteger:quantity], @"quantity",  nil];
    SVService *service = [[SVService alloc] init];
    [service addToCart:dict usingBlock:^(NSString *resultMessage) {
        if (resultMessage != nil) {
            
        }
        
        
    }];
    
    
}

@end
