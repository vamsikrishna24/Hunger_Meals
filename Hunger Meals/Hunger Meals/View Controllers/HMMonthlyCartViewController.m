 //
//  HMMonthlyCartViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 25/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMMonthlyCartViewController.h"
#import "HMMonthlyCartTableViewCell.h"
#import "SVService.h"
#import "Itemlist.h"
#import "Tax.h"
#import "HMPaymentTypeSelectionViewController.h"
#import "HmDelieveriAddressViewController.h"
#import "HMAddressesListViewController.h"

@interface HMMonthlyCartViewController (){
    NSMutableArray *lunchItemsArray;
    NSMutableArray *dinnerItemsArray;
    NSMutableArray *monthlyCartItemsArray;

    NSString *rsString;
    float totalAmount;
    float taxSum;
    float coupondCodeDiscount;
    int quantity;
    BOOL isCouponApplied;
}
@property (weak, nonatomic) IBOutlet UILabel *cartEmptyLabel;

@end

@implementation HMMonthlyCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isCouponApplied = NO;
    self.cartEmptyLabel.hidden = YES;
    self.title = @"Monthly Meal Cart";
    quantity = 0;
    monthlyCartItemsArray = [[NSMutableArray alloc] init];
    lunchItemsArray = [[NSMutableArray alloc] init];
    dinnerItemsArray = [[NSMutableArray alloc] init];
    
   // self.cartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;


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
    
    [self fetchMonthlyProducts];
}

- (void)fetchMonthlyProducts{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"lunch",@"type", nil];
    SVService *service = [[SVService alloc] init];
    [service currentUserMonthlyCartWithDict:dict usingBlock:^(NSMutableArray *resultArray) {
        
        if (resultArray.count > 0) {
            lunchItemsArray = [resultArray mutableCopy];
            [monthlyCartItemsArray addObjectsFromArray:lunchItemsArray];
        }
        
        NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"dinner",@"type", nil];
        [service currentUserMonthlyCartWithDict:dict usingBlock:^(NSMutableArray *resultArray) {
            
            if (resultArray.count > 0) {
                dinnerItemsArray = [resultArray mutableCopy];
                [monthlyCartItemsArray addObjectsFromArray:dinnerItemsArray];
            }
            
            totalAmount = 0;
            for (NSDictionary *itemDict in monthlyCartItemsArray) {
                totalAmount += [itemDict[@"price"] floatValue];
            }
            
            [_cartTableView reloadData];
            [self calculation];
            
            [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];

        }];
    }];
    
}
//-(void)fetchAndLoadData{
//    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
//    
//    SVService *service = [[SVService alloc] init];
//    [service getCartDatausingBlock:^(NSMutableArray *resultArray) {
//        
//        if (resultArray.count != 0 || resultArray != nil) {
//            cartItemsArray = [resultArray mutableCopy];
//            [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)cartItemsArray.count];
//        }
//        
//        [_cartTableView reloadData];
//        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
//    }];
//    
//}

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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (monthlyCartItemsArray.count == 0) {
        self.cartEmptyLabel.hidden = NO;
        
    }else {
        self.cartEmptyLabel.hidden = YES;
        
    }
    
    //number of rows in each section
    if (section == 0 ) {
        return lunchItemsArray.count;
    }
    else {
        return dinnerItemsArray.count;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cartCell = @"CartCellIdentifier";
    HMMonthlyCartTableViewCell *cell = [self.cartTableView dequeueReusableCellWithIdentifier:cartCell];
    if (cell == nil) {
        cell = [[HMMonthlyCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cartCell];
    }
    
    NSDictionary *mealsDict;
    if (indexPath.section == 0) {
        mealsDict = [lunchItemsArray objectAtIndex:indexPath.row];
    }
    else {
        mealsDict = [dinnerItemsArray objectAtIndex:indexPath.row];
    }
    
    cell.cartItemTitle.text = [mealsDict objectForKey:@"name"];
    cell.countLabel.text = [NSString stringWithFormat:@"Qty: %@", [mealsDict objectForKey:@"quantity"]];
    cell.totalPriceLabel.text = [NSString stringWithFormat:@"₹ %@", [mealsDict objectForKey:@"price"]];
    
    //    CartItem *cartObject = [itemsListArray objectAtIndex:indexPath.row];
    //    cell.incrementButton.tag = indexPath.row;
    //    cell.decrimentButton.tag = indexPath.row;
    //    cell.cancelButton.tag = indexPath.row;
    //
    //    cell.totalPriceLabel.text = [NSString stringWithFormat:@"%@ ₹",cartObject.price];
    //    cell.cartItemTitle.text = cartObject.product.name;
    //    cell.countLabel.text = cartObject.quantity;
    //
    //    self.quantityString = cartObject.quantity;
    //
    //    NSString *string = [NSString stringWithFormat:@"%@%@",imageAmazonlink,cartObject.product.image_url];
    //    [cell.cartItemsImageView sd_setImageWithURL:[NSURL URLWithString:string]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return @"Lunch";
    }
    else if(section == 1){
        return @"Dinner";
    }
    
    return @"";
}

-(void)calculation{
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
    rsString = [ NSString stringWithFormat:@"%.2f ₹",value1];
    self.cessValueLabel.text = rsString;
    
    value1 = [[taxDict objectForKey:@"service_charge"] floatValue];
    value1 = (value1*total)/100;
    rsString = [ NSString stringWithFormat:@"%.2f ₹",value1];
    self.serviceChargeValueLabel.text = rsString;
    
    taxSum = taxSum + value1;
    value1 = [[taxDict objectForKey:@"service_tax"] floatValue];
    value1 = (value1*total)/100;
    rsString = [ NSString stringWithFormat:@"%.2f ₹",value1];
    self.serviceTaxValueLabel.text = rsString;
    taxSum = taxSum + value1;
    
    value1 = [[taxDict objectForKey:@"VAT"] floatValue];
    value1 = (value1*total)/100;
    rsString = [ NSString stringWithFormat:@"%.2f ₹",value1];
    self.vatValueLabel.text = rsString;
    taxSum = taxSum + value1;
    
    value1 = [[taxDict objectForKey:@"delivery_charge"] floatValue];
    value1 = (value1*total)/100;
    rsString = [ NSString stringWithFormat:@"%.2f ₹",value1];
    self.dekieveryChagesValueLabel.text = rsString;
    taxSum = taxSum + value1;
    
    value1 = [[taxDict objectForKey:@"packing_charge"] floatValue];
    value1 = (value1*total)/100;
    rsString = [ NSString stringWithFormat:@"%.2f ₹",value1];
    self.packagingValueLabel.text = rsString;
    taxSum = taxSum + value1;
    totalAmount = totalAmount + taxSum;
    self.totalPrice.text = [NSString stringWithFormat:@"%.2f ₹",totalAmount] ;
    
    
    
}

//- (IBAction)deleteCartItem:(id)sender{
//    UIButton *btn = (UIButton *)sender;
//    CartItem *productObject = cartItemsArray[btn.tag];
//    [cartItemsArray removeObject:productObject];
//    [_cartTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.cartTableView reloadData];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: productObject.inventories_id, @"inventories_id", @"0", @"quantity",  nil];
//    SVService *service = [[SVService alloc] init];
//    [service addToCart:dict usingBlock:^(NSString *resultMessage) {
//        if (resultMessage != nil && [resultMessage isEqualToString:@"Item has been removed from cart"]) {
//            
//        }
//    }];
//}

- (IBAction)applyButtonAction:(id)sender {
    if (totalAmount > 0) {
        
        [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.promoCodeTextField.text,@"code",nil];
        SVService *service = [[SVService alloc] init];
        
        [service couponCode:dict usingBlock:^(NSString *resultArray) {
            isCouponApplied = YES;
            self.amountDiscountLabel.text = [NSString stringWithFormat:@"- %.2f ₹",[[resultArray valueForKey:@"amount"]floatValue]];
            coupondCodeDiscount = [[resultArray valueForKey:@"amount"]floatValue];
            totalAmount = totalAmount - coupondCodeDiscount;
            self.totalPrice.text = [NSString stringWithFormat:@"%.2f ₹",totalAmount];
            self.applyButton.enabled = NO;
            [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
            
        }];
        
    }
    
}

-(IBAction)makePaymentClicked:(id)sender{
    if (monthlyCartItemsArray.count == 0) {
        [self showAlertWithTitle:@"Hunger Meals" andMessage:@"No items found in your cart to proceed further. Please add items to cart."];
    }
    else {
    [self performSegueWithIdentifier:@"ToPaymentSelection" sender:nil];
    }
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    [BTAlertController showAlertWithMessage:message andTitle:title andOkButtonTitle:nil andCancelTitle:@"Ok" andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        
    }];
    
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
        self.amountDiscountLabel.text = [NSString stringWithFormat:@"0"];
        self.totalPrice.text = [NSString stringWithFormat:@"%.2f ₹",totalAmount];
        
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
        HMAddressesListViewController *addressVC = (HMAddressesListViewController *)segue.destinationViewController;
        addressVC.priceString = [NSString stringWithFormat:@"%f",totalAmount];
        
    }
}


@end
