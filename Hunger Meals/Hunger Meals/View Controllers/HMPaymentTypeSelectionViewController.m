//
//  HMPaymentTypeSelectionViewController.m
//  Hunger Meals
//
//  Created by Vamsi T on 28/07/2016.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMPaymentTypeSelectionViewController.h"
#import "PaymentPageViewController.h"
#import "PayTMViewController.h"

@interface HMPaymentTypeSelectionViewController ()
{
    NSString *selectedPaymentMethod;
}
@end

@implementation HMPaymentTypeSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.paytmButton.layer setValue:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
    selectedPaymentMethod = @"PAYTM";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)paytmOptionSelected:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if ([btn.layer valueForKey:@"isSelected"]) {
        [btn.layer setValue:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
    }
    else {
        [btn.layer setValue:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
    }
    
    [self.payUButton setImage:[UIImage imageNamed:@"Radio_Unchecked"] forState:UIControlStateNormal];
    [self.paytmButton setImage:[UIImage imageNamed:@"Radio_Checked"] forState:UIControlStateNormal];

    selectedPaymentMethod = @"PAYTM";
}

- (IBAction)payUmoneyOptionSelected:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if ([btn.layer valueForKey:@"isSelected"]) {
        [btn.layer setValue:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
    }
    else {
        [btn.layer setValue:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
    }
    [self.paytmButton setImage:[UIImage imageNamed:@"Radio_Unchecked"] forState:UIControlStateNormal];
    [self.payUButton setImage:[UIImage imageNamed:@"Radio_Checked"] forState:UIControlStateNormal];

    selectedPaymentMethod = @"PAYUMONEY";
}

- (IBAction)MakeAPaymentButtonPressed:(id)sender{
    
    if ([selectedPaymentMethod isEqualToString:@"PAYTM"]) {
        [self makePaymentWithPayTM:nil];
    }
    else if ([selectedPaymentMethod isEqualToString:@"PAYUMONEY"]){
        [self performSegueWithIdentifier:@"ToPayUMoney" sender:self];
    
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ToPayUMoney"]){
        PaymentPageViewController *payUMoney = (PaymentPageViewController *)segue.destinationViewController;
        payUMoney.paymentString = self.PaymentAmountString;
    }else{
        PayTMViewController *paytm = (PayTMViewController *)segue.destinationViewController;
        paytm.paymentString = self.PaymentAmountString;
    }
}
+(NSString*)generateOrderIDWithPrefix:(NSString *)prefix
{
    srand ( (unsigned)time(NULL) );
    int randomNo = rand(); //just randomizing the number
    NSString *orderID = [NSString stringWithFormat:@"%@%d", prefix, randomNo];
    return orderID;
}

-(void)showController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil)
        [self.navigationController pushViewController:controller animated:YES];
    else
        [self presentViewController:controller animated:YES
                         completion:^{
                             
                         }];
}

-(void)removeController:(PGTransactionViewController *)controller
{
    if (self.navigationController != nil)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [controller dismissViewControllerAnimated:YES
                                       completion:^{
                                       }];
}

-(IBAction)makePaymentWithPayTM:(id)sender
{
    //Step 1: Create a default merchant config object
    PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];
    
    //Step 2: If you have your own checksum generation and validation url set this here. Otherwise use the default Paytm urls
    mc.checksumGenerationURL = @"https://pguat.paytm.com/paytmchecksum/paytmCheckSumGenerator.jsp";
    mc.checksumValidationURL = @"https://pguat.paytm.com/paytmchecksum/paytmCheckSumVerify.jsp";
    
    //Step 3: Create the order with whatever params you want to add. But make sure that you include the merchant mandatory params
    NSMutableDictionary *orderDict = [NSMutableDictionary new];
    //Merchant configuration in the order object
    orderDict[@"MID"] = @"RSVFoo68765272894551";
    orderDict[@"CHANNEL_ID"] = @"WEB";
    orderDict[@"INDUSTRY_TYPE_ID"] = @"Retail110";
    orderDict[@"WEBSITE"] = @"RSVFoodWEB";
    //Order configuration in the order object
    orderDict[@"TXN_AMOUNT"] = self.PaymentAmountString;
    orderDict[@"ORDER_ID"] = [HMPaymentTypeSelectionViewController generateOrderIDWithPrefix:@"666"];
    orderDict[@"REQUEST_TYPE"] = @"DEFAULT";
    orderDict[@"CUST_ID"] = @"1234567890";
    
    PGOrder *order = [PGOrder orderWithParams:orderDict];
    
    //Step 4: Choose the PG server. In your production build dont call selectServerDialog. Just create a instance of the
    //PGTransactionViewController and set the serverType to eServerTypeProduction
    
    PGTransactionViewController *txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
    txnController.serverType = eServerTypeProduction;
    txnController.merchant = mc;
    txnController.delegate = self;
    [self showController:txnController];
    
}

#pragma mark PGTransactionViewController delegate

- (void)didSucceedTransaction:(PGTransactionViewController *)controller
                     response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didSucceedTransactionresponse= %@", response);
    NSString *title = [NSString stringWithFormat:@"Your order  was completed successfully. \n %@", response[@"ORDERID"]];
    [[[UIAlertView alloc] initWithTitle:title message:[response description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    [self removeController:controller];
}

- (void)didFailTransaction:(PGTransactionViewController *)controller error:(NSError *)error response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didFailTransaction error = %@ response= %@", error, response);
    if (response)
    {
        [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:[response description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else if (error)
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    [self removeController:controller];
}

- (void)didCancelTransaction:(PGTransactionViewController *)controller error:(NSError*)error response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didCancelTransaction error = %@ response= %@", error, response);
    NSString *msg = nil;
    if (!error) msg = [NSString stringWithFormat:@"Your transaction cancellation successful"];
    else msg = [NSString stringWithFormat:@"Your transaction cancellation unsuccessful"];
    
    [[[UIAlertView alloc] initWithTitle:@"Transaction Cancel" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self removeController:controller];
}

- (void)didFinishCASTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didFinishCASTransaction:response = %@", response);
}

@end
