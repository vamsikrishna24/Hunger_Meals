//
//  AddonsViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "AddonsViewController.h"
#import "MealsTableViewCell.h"
#import "SVService.h"
#import "Product.h"
#import "Inventory.h"

@interface AddonsViewController (){
    BOOL isCellExpanded;
    BOOL isVegSwitchOn;

    NSInteger tableViewHeight;
    NSMutableArray *productObjectsArray;

}

@property(nonatomic, strong) NSMutableArray *dishImagesArray;
@property (weak, nonatomic) IBOutlet UITableView *addOnTableView;
@property (strong, nonatomic) NSArray *filteredProdcutsArray;



@end

@implementation AddonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isCellExpanded = NO;
    tableViewHeight = 210;
    [self fetchAndLoadData];
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
    
    Product *product = productObjectsArray[indexPath.row];
    if (isVegSwitchOn) {
        product = _filteredProdcutsArray[indexPath.row];
    }
    
    cell.addToCartButton.tag = indexPath.row;
    cell.incrementButton.tag = indexPath.row;
    cell.decrementButton.tag = indexPath.row;
    
    Inventory *inventory = product.inventories[0];
    
    if([product.label  isEqual: @"veg"]){
        cell.vegNonVegColorView.backgroundColor = [UIColor greenColor];
    }else if([product.label  isEqual: @"non-veg"]){
        cell.vegNonVegColorView.backgroundColor = [UIColor redColor];
        
    }

    NSString *string = [NSString stringWithFormat:@"%@%@",imageAmazonlink,product.image_url];
    [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:string]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    cell.titleLabel.text = product.name;
    cell.descriptionView.text = product.description;
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
    [service getAddOnProductsDataUsingBlock:dict usingBlock:^(NSMutableArray *resultArray) {
        
        if (resultArray.count == 0 || resultArray == nil) {
            //[self displayMessageWhenNoData];
        }
        productObjectsArray = [resultArray copy];
        [self.addOnTableView reloadData];
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}

-(IBAction)vegFilterSwitchClicked:(id)sender{
    UISwitch *vegSwitch = (UISwitch *)sender;
    isVegSwitchOn = vegSwitch.isOn;
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.label == %@",@"veg"];
    self.filteredProdcutsArray = [productObjectsArray filteredArrayUsingPredicate:bPredicate];
    
    [_addOnTableView reloadData];
    
}

- (IBAction)addToCartAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    MealsTableViewCell *mealsCell = (MealsTableViewCell*)[_addOnTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    Product *productObject = productObjectsArray[btn.tag];
    NSInteger quantity = [mealsCell.countLabel.text intValue];
    NSArray *array = productObject.inventories[0];
    NSString *stringArray = [array valueForKey:@"id"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: stringArray, @"inventories_id",[NSNumber numberWithInteger:quantity], @"quantity",  nil];
    SVService *service = [[SVService alloc] init];
    [service addToCart:dict usingBlock:^(NSString *resultMessage) {
        if (resultMessage != nil) {
            
        }
        
        
    }];
    
    
}


@end
