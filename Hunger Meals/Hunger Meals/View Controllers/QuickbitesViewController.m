//
//  QuickbitesViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "QuickbitesViewController.h"
#import "MealsTableViewCell.h"
#import "SVService.h"
#import "Product.h"
#import "Inventory.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HMCartItemsViewController.h"

@interface QuickbitesViewController (){
    MealsTableViewCell *cell;
    BOOL isCellExpanded;
    BOOL isVegSwitchOn;
    NSInteger quantity;
}

@property(nonatomic, strong) NSMutableArray *inventoryObjectArray;
@property (weak, nonatomic) IBOutlet UITableView *quickBitesTableView;
@property (strong, nonatomic) NSMutableArray *productObjectsArray;
@property (strong, nonatomic) NSArray *filteredProdcutsArray;


@property (strong, nonatomic) NSMutableArray *labelArray;



@end

@implementation QuickbitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _productObjectsArray = [[NSMutableArray alloc] init];
    _labelArray = [[NSMutableArray alloc]init];
    //self.dishImagesArray = [[NSMutableArray alloc]initWithObjects:@"dish1",@"dish2",@"dish3",@"dish4",@"dish5",@"dish6",@"dish7",@"dish8",@"dish9",@"dish10",@"dish11",@"dish12",@"dish13",@"dish14",@"dish15",@"dish16", nil];


   // [self.quickBitesTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

    if(quantity >= 1){
    cell.addToCartButton.hidden = NO;
    }
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
    [service getQuickBitesProductsDataUsingBlock:dict usingBlock:^(NSMutableArray *resultArray) {
        
        if (resultArray.count == 0 || resultArray == nil) {
            //[self displayMessageWhenNoData];
        }
        
        _productObjectsArray = [resultArray copy];
        [self.quickBitesTableView reloadData];
        
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
    
  
    cell.priceLabel.text = @"";
    cell.titleLabel.text = @"";
    cell.descriptionView.text = @"";
    cell.itemImageView.image = nil;
    if (cell == nil) {
        cell = [[MealsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    //Making selection style none
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //[cell.contentView setLayoutMargins:UIEdgeInsetsMake(15, 0, 0, 0)];
    
    Product *product = _productObjectsArray[indexPath.row];
    if (isVegSwitchOn) {
        product = _filteredProdcutsArray[indexPath.row];
    }
    
    if([product.label  isEqual: @"veg"]){
        cell.vegImageView.image = [UIImage imageNamed:@"Veg"];
       // cell.vegNonVegColorView.backgroundColor = [UIColor greenColor];
        
    }else if([product.label  isEqual: @"non-veg"]){
        //cell.vegNonVegColorView.backgroundColor = [UIColor redColor];
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
    
  //  NSString *imageName = [NSString stringWithFormat:@"Dish_Images/%@.jpg",self.dishImagesArray[indexPath.row]];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",imageAmazonlink,product.image_url];
    [cell.itemImageView sd_setImageWithURL:[NSURL URLWithString:string]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    cell.titleLabel.text =product.name;
    cell.descriptionView.text = product.description;
    if ([product.description isEqualToString: @""]) {
        cell.descriptionHeightConstraint.constant = 0;
    }
    else {
        CGSize newSize = [cell.descriptionView sizeThatFits:CGSizeMake(cell.descriptionView.frame.size.width, MAXFLOAT)];
        cell.descriptionHeightConstraint.constant = newSize.height;
    }
    
    cell.priceLabel.text = [NSString stringWithFormat:@"₹ %@",product.price];
    _labelArray = [_productObjectsArray valueForKey:@"label"];

    return cell;
}

-(IBAction)vegFilterSwitchClicked:(id)sender{
    UISwitch *vegSwitch = (UISwitch *)sender;
    isVegSwitchOn = vegSwitch.isOn;
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"SELF.label == %@",@"veg"];
    self.filteredProdcutsArray = [self.productObjectsArray filteredArrayUsingPredicate:bPredicate];
    [_quickBitesTableView reloadData];

   
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

- (IBAction)nonVegetarianAction:(id)sender {
    NSString *tem = self.nonVegetarianButtonOutlet.titleLabel.text;
    
    if (tem != nil && ![tem isEqualToString:@""]) {
        NSMutableAttributedString *temString=[[NSMutableAttributedString alloc]initWithString:tem];
        [temString addAttribute:NSUnderlineStyleAttributeName
                          value:[NSNumber numberWithInt:1]
                          range:(NSRange){0,[temString length]}];
        
        self.nonVegetarianButtonOutlet.titleLabel.attributedText = temString;
   }

}

- (IBAction)vegetarianAction:(id)sender {
    NSString *tem = self.vegetarianButtonOutlet.titleLabel.text;
    
    if (tem != nil && ![tem isEqualToString:@""]) {
        NSMutableAttributedString *temString=[[NSMutableAttributedString alloc]initWithString:tem];
        [temString addAttribute:NSUnderlineStyleAttributeName
                          value:[NSNumber numberWithInt:1]
                          range:(NSRange){0,[temString length]}];
        
        self.vegetarianButtonOutlet.titleLabel.attributedText = temString;
        self.nonVegetarianButtonOutlet.selected = NO;

    }
    

}

- (IBAction)addToCartAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    MealsTableViewCell *mealsCell = (MealsTableViewCell*)[_quickBitesTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    Product *productObject = _productObjectsArray[btn.tag];
    NSInteger quantity = [mealsCell.countLabel.text intValue];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: productObject.id, @"inventories_id",[NSNumber numberWithInteger:quantity], @"quantity",  nil];
    
    [Utility saveTocart:dict[@"inventories_id"] quantity:quantity];
    

    SVService *service = [[SVService alloc] init];
    [service addToCart:dict usingBlock:^(NSString *resultMessage) {
        if (resultMessage != nil) {
            
        }
        
        
    }];
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//
//    [defaults s];
}

@end
