//
//  NorthIndianViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "NorthIndianViewController.h"
#import "MealsTableViewCell.h"
#import "SVService.h"
#import "Product.h"
#import "Inventory.h"

@interface NorthIndianViewController (){
    BOOL isCellExpanded;
    BOOL isVegSwitchOn;
    MealsTableViewCell *cell;
    NSInteger quantity;

    NSInteger tableViewHeight;
    NSMutableArray *productObjectsArray;


}

@property(nonatomic, strong) NSMutableArray *dishImagesArray;
@property (strong, nonatomic) NSArray *filteredProdcutsArray;


@property (weak, nonatomic) IBOutlet UITableView *northIndianTableView;


@end

@implementation NorthIndianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dishImagesArray = [[NSMutableArray alloc]initWithObjects:@"dish1",@"dish2",@"dish3",@"dish4",@"dish5",@"dish6",@"dish7",@"dish8",@"dish9",@"dish10",@"dish11",@"dish12",@"dish13",@"dish14",@"dish15",@"dish16", nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchAndLoadData]; 
    isCellExpanded = NO;
    tableViewHeight = 210;

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isVegSwitchOn) {
        return _filteredProdcutsArray.count;
    }
    return productObjectsArray.count;
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
    
    Product *product = productObjectsArray[indexPath.row];
    if (isVegSwitchOn) {
        product = _filteredProdcutsArray[indexPath.row];
    }
    
    NSDictionary *inventory = [product.inventories firstObject];

    if([product.label  isEqual: @"veg"]){
       // cell.vegNonVegColorView.backgroundColor = [UIColor greenColor];
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

    cell.addToCartButton.tag = indexPath.row;
    cell.incrementButton.tag = indexPath.row;
    cell.decrementButton.tag = indexPath.row;
    

    NSString *string = [NSString stringWithFormat:@"%@%@",imageAmazonlink,product.image_url];
    [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:string]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.titleLabel.text = product.name;
    cell.descriptionView.text = product.description;
    
    if ([product.description isEqualToString: @""]) {
        cell.descriptionHeightConstraint.constant = 0;
    }
    else {
        CGSize newSize = [cell.descriptionView sizeThatFits:CGSizeMake(cell.descriptionView.frame.size.width, MAXFLOAT)];
        cell.descriptionHeightConstraint.constant = newSize.height;
    }

    cell.priceLabel.text = [NSString stringWithFormat:@"₹ %@",[inventory valueForKey: @"price"]];
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
    Product *product = [productObjectsArray objectAtIndex:indexPath.row];
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

-(void)fetchAndLoadData{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: kToken,@"token",  nil];
    SVService *service = [[SVService alloc] init];
    [service getNorthIndianProductsDataUsingBlock:dict usingBlock:^(NSMutableArray *resultArray) {
        
        if (resultArray.count == 0 || resultArray == nil) {
            //[self displayMessageWhenNoData];
        }
        productObjectsArray = [resultArray copy];
        [self.northIndianTableView reloadData];
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    //    NSLog(@"current Index : %ld",(long)index);
    //    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}

-(IBAction)vegFilterSwitchClicked:(id)sender{
    UISwitch *vegSwitch = (UISwitch *)sender;
    isVegSwitchOn = vegSwitch.isOn;
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.label == %@",@"veg"];
    self.filteredProdcutsArray = [productObjectsArray filteredArrayUsingPredicate:bPredicate];
    
    [_northIndianTableView reloadData];
    
}

- (IBAction)addToCartAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    MealsTableViewCell *mealsCell = (MealsTableViewCell*)[_northIndianTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    Product *productObject = productObjectsArray[btn.tag];
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
