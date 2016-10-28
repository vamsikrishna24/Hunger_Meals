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


@interface HMMonthlyCartViewController (){
    NSMutableArray *cartItemsArray;
    NSMutableArray *monthlyCartItemsArray;

    NSString *rsString;
    float totalAmount;
    float taxSum;
    float coupondCodeDiscount;
    int quantity;
    BOOL isCouponApplied;
    NSMutableArray *itemsListArray;
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
        
        monthlyCartItemsArray = resultArray;
        [self.cartTableView reloadData];

        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    totalAmount = 0;
//    for (int row = 0; row < monthlyCartItemsArray.count ; row++) {
//        Itemlist *itemObject = itemsListArray[row];
//        totalAmount += [cartItemObject.price floatValue];
//    }
//    
//    [self calculation];
//    
//    if (monthlyCartItemsArray.count == 0) {
//        self.cartEmptyLabel.hidden = NO;
//        
//    }else {
//        self.cartEmptyLabel.hidden = YES;
//        
//    }
    return [monthlyCartItemsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cartCell = @"CartCellIdentifier";
    HMMonthlyCartTableViewCell *cell = [self.cartTableView dequeueReusableCellWithIdentifier:cartCell];
    if (cell == nil) {
        cell = [[HMMonthlyCartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cartCell];
    }
    //cell.totalPriceLabel.text = [NSString stringWithFormat:@"%@ ₹",@"23"];
        cell.cartItemTitle.text = [monthlyCartItemsArray valueForKey:@"name"][indexPath.row];
        cell.countLabel.text = [monthlyCartItemsArray valueForKey:@"quantity"][indexPath.row];
      //  self.quantityString = [monthlyCartItemsArray valueForKey:@"quantity"][indexPath.row];
       cell.totalPriceLabel.text = [monthlyCartItemsArray valueForKey:@"price"][indexPath.row];

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
- (IBAction)updateProductQuantiy:(id)sender{
//    UIButton *btn = (UIButton *)sender;
//    HMMonthlyCartTableViewCell *mealsCell = (HMMonthlyCartTableViewCell*)[_cartTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag inSection:0]];
//    CartItem *cartItemObject = cartItemsArray[btn.tag];
//    quantity = [mealsCell.countLabel.text intValue];
//    int priceOfItem= [cartItemObject.price intValue]/[cartItemObject.quantity intValue];
//    mealsCell.totalPriceLabel.text = [NSString stringWithFormat:@"%d ₹",priceOfItem * quantity];
//    
//    //Updating the latest cart details again
//    cartItemObject.price = [NSString stringWithFormat:@"%d", priceOfItem*quantity];
//    cartItemObject.quantity = [NSString stringWithFormat:@"%d", quantity];
//    
//    totalAmount = 0;
//    for (int row = 0; row < cartItemsArray.count ; row++) {
//        CartItem *cartItemObject = cartItemsArray[row];
//        totalAmount += [cartItemObject.price floatValue];
//    }
//    
//    [self calculation];
//    NSString *stringArray =cartItemObject.inventories_id;
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: stringArray, @"inventories_id",[NSNumber numberWithInteger:quantity], @"quantity",  nil];
//    
//    
//    SVService *service = [[SVService alloc] init];
//    [service addToCart:dict usingBlock:^(NSString *resultMessage) {
//        if (resultMessage != nil) {
//            
//        }
//        
//    }];
    
    
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
        HmDelieveriAddressViewController *deliveryVC = (HmDelieveriAddressViewController *)segue.destinationViewController;
        deliveryVC.PaymentAmountString = [NSString stringWithFormat:@"%f",totalAmount];
        
        
    }
}


@end
