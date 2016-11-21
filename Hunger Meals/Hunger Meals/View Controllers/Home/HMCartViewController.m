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
#import "Tax.h"
#import "HMPaymentTypeSelectionViewController.h"
#import "HmDelieveriAddressViewController.h"


@interface HMCartViewController (){
    NSMutableArray *cartItemsArray;
    NSString *rsString;
    float totalAmount;
    float taxSum;
    float coupondCodeDiscount;
    int quantity;
    BOOL isCouponApplied;
}
@property (weak, nonatomic) IBOutlet UILabel *cartEmptyLabel;
@property (weak, nonatomic) IBOutlet UIView *cartTaxView;

@end

@implementation HMCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isCouponApplied = NO;
    self.cartEmptyLabel.hidden = YES;
    self.title = @"Cart";
    quantity = 0;
    self.cartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cartTableView.tableFooterView = self.cartTaxView;

    
    [self.promoCodeTextField setValue:[UIFont fontWithName: @"Roboto-Light" size: 13] forKeyPath:@"_placeholderLabel.font"];
    
    UIColor *color = [UIColor colorWithRed:119.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1.0];
    self.promoCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Promo Code" attributes:@{NSForegroundColorAttributeName: color}];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.promoCodeTextField.frame.size.height - 1, self.promoCodeTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.promoCodeTextField.layer addSublayer:bottomBorder];
    
    //    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    //
    //    SVService *service = [[SVService alloc] init];
    //
    //    [service getLocationsDataUsingBlock:^(NSMutableArray *resultArray) {
    //
    //
    //
    //
    //        [self performSelectorOnMainThread:@selector(hideActivityIndicator:) withObject:kIndicatorTitle waitUntilDone:NO];
    //    }];
    
    
    
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
            cartItemsArray = [resultArray mutableCopy];
            APPDELEGATE.cartItemsValue = cartItemsArray.count;
            [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)cartItemsArray.count];
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
    
    totalAmount = 0;
    for (int row = 0; row < cartItemsArray.count ; row++) {
        CartItem *cartItemObject = cartItemsArray[row];
        totalAmount += [cartItemObject.price floatValue];
    }
    
    [self calculation];
    
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
    
    cell.totalPriceLabel.text = [NSString stringWithFormat:@"₹ %@",cartObject.price];
    cell.cartItemTitle.text = cartObject.product.name;
    cell.countLabel.text = cartObject.quantity;
    
    self.quantityString = cartObject.quantity;
    
    NSString *string = [NSString stringWithFormat:@"%@%@",imageAmazonlink,cartObject.product.image_url];
    [cell.cartItemsImageView sd_setImageWithURL:[NSURL URLWithString:string]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    return cell;
    
}

-(void)calculation{
    Tax *taxObject = [[Tax alloc]init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Tax" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    NSMutableDictionary *taxDict = [[NSMutableDictionary alloc]init];
    taxSum = 0.0;
    taxDict = [json valueForKey:@"tax"];
    float value1 = 0.0;
    int total = totalAmount;
    value1 = [[taxDict objectForKey:@"CESS"] floatValue];
    value1 = (value1*total)/100;
    taxSum = value1;
    rsString = [ NSString stringWithFormat:@"₹ %.2f",value1];
    self.cessValueLabel.text = rsString;
    
    value1 = [[taxDict objectForKey:@"service_charge"] floatValue];
    value1 = (value1*total)/100;
    rsString = [ NSString stringWithFormat:@"₹ %.2f",value1];
    self.serviceChargeValueLabel.text = rsString;
    
    taxSum = taxSum + value1;
    value1 = [[taxDict objectForKey:@"service_tax"] floatValue];
    value1 = (value1*total)/100;
    rsString = [ NSString stringWithFormat:@"₹ %.2f",value1];
    self.serviceTaxValueLabel.text = rsString;
    taxSum = taxSum + value1;
    
    value1 = [[taxDict objectForKey:@"VAT"] floatValue];
    value1 = (value1*total)/100;
    rsString = [ NSString stringWithFormat:@"₹ %.2f",value1];
    self.vatValueLabel.text = rsString;
    taxSum = taxSum + value1;
    
    value1 = [[taxDict objectForKey:@"delivery_charge"] floatValue];
    value1 = (value1*total)/100;
    rsString = [ NSString stringWithFormat:@"₹ %.2f",value1];
    self.dekieveryChagesValueLabel.text = rsString;
    taxSum = taxSum + value1;
    
    value1 = [[taxDict objectForKey:@"packing_charge"] floatValue];
    value1 = (value1*total)/100;
    rsString = [ NSString stringWithFormat:@"₹ %.2f",value1];
    self.packagingValueLabel.text = rsString;
    taxSum = taxSum + value1;
    totalAmount = totalAmount + taxSum;
    self.totalPrice.text = [NSString stringWithFormat:@"₹ %.2f",totalAmount] ;
    
    
    
}
- (IBAction)updateProductQuantiy:(id)sender{
    UIButton *btn = (UIButton *)sender;
    HMCartTableViewCell *mealsCell = (HMCartTableViewCell*)[_cartTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
    CartItem *cartItemObject = cartItemsArray[btn.tag];
    quantity = [mealsCell.countLabel.text intValue];
    int priceOfItem= [cartItemObject.price intValue]/[cartItemObject.quantity intValue];
    mealsCell.totalPriceLabel.text = [NSString stringWithFormat:@"₹ %d",priceOfItem * quantity];
    
    //Updating the latest cart details again
    cartItemObject.price = [NSString stringWithFormat:@"%d", priceOfItem*quantity];
    cartItemObject.quantity = [NSString stringWithFormat:@"%d", quantity];
    
    totalAmount = 0;
    for (int row = 0; row < cartItemsArray.count ; row++) {
        CartItem *cartItemObject = cartItemsArray[row];
        totalAmount += [cartItemObject.price floatValue];
    }
    
    [self calculation];
    NSString *stringArray =cartItemObject.inventories_id;
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: stringArray, @"inventories_id",[NSNumber numberWithInteger:quantity], @"quantity",  nil];
    
    
    SVService *service = [[SVService alloc] init];
    [service addToCart:dict usingBlock:^(NSString *resultMessage) {
        if (resultMessage != nil) {
            
        }
        
    }];
    
    
}

- (IBAction)deleteCartItem:(id)sender{
    UIButton *btn = (UIButton *)sender;
    CartItem *productObject = cartItemsArray[btn.tag];
    APPDELEGATE.cartItemsValue--;
    [[APPDELEGATE.homeNavigationController.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld",(long)APPDELEGATE.cartItemsValue]];    [cartItemsArray removeObject:productObject];
    [_cartTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.cartTableView reloadData];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: productObject.inventories_id, @"inventories_id", @"0", @"quantity",  nil];
    
    SVService *service = [[SVService alloc] init];
    [service addToCart:dict usingBlock:^(NSString *resultMessage) {
        if (resultMessage != nil && [resultMessage isEqualToString:@"Item has been removed from cart"]) {
            
        }
    }];
    
   }
-(void)updateCartItemsBadgeValue{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    SVService *service = [[SVService alloc] init];
    [service getCartDatausingBlock:^(NSMutableArray *resultArray) {
        
        if (resultArray.count != 0 || resultArray != nil) {
            APPDELEGATE.cartItemsValue = resultArray.count;
            [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%lu",(unsigned long)resultArray.count]];
        }
        
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}
- (IBAction)applyButtonAction:(id)sender {
    if (totalAmount > 0) {
        
        [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.promoCodeTextField.text,@"code",nil];
        SVService *service = [[SVService alloc] init];
        
        [service couponCode:dict usingBlock:^(NSString *resultArray) {
            isCouponApplied = YES;
            self.amountDiscountLabel.text = [NSString stringWithFormat:@"₹ - %.2f",[[resultArray valueForKey:@"amount"]floatValue]];
            coupondCodeDiscount = [[resultArray valueForKey:@"amount"]floatValue];
            totalAmount = totalAmount - coupondCodeDiscount;
            self.totalPrice.text = [NSString stringWithFormat:@"₹ %.2f",totalAmount];
            self.applyButton.enabled = NO;
            [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
            
        }];
        
    }
    
}

#pragma Mark - TextField Delegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.length == 1 && range.location == 0) {
        self.applyButton.enabled = YES;
        if(isCouponApplied == YES) {
            totalAmount = totalAmount + coupondCodeDiscount;
        }
        isCouponApplied = NO;
        self.amountDiscountLabel.text = [NSString stringWithFormat:@"₹ 0.00"];
        self.totalPrice.text = [NSString stringWithFormat:@"₹ %.2f",totalAmount];
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    return  YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ToPaymentSelection"]){
        HmDelieveriAddressViewController *deliveryVC = (HmDelieveriAddressViewController *)segue.destinationViewController;
        deliveryVC.PaymentAmountString = [NSString stringWithFormat:@"%f",totalAmount];
        
        
    }
}
@end
