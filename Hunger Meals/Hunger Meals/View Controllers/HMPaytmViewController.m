//
//  HMPaytmViewController.m
//  Hunger Meals
//
//  Created by Uber - Sivajee Battina on 06/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMPaytmViewController.h"

@interface HMPaytmViewController ()

@end

@implementation HMPaytmViewController

+(NSString*)generateOrderIDWithPrefix:(NSString *)prefix
{
    srand ( (unsigned)time(NULL) );
    int randomNo = rand(); //just randomizing the number
    NSString *orderID = [NSString stringWithFormat:@"%@%d", prefix, randomNo];
    return orderID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makePayment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)makePayment
{
    //Step 1: Create a default merchant config object
    PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];
    
    //Step 2: If you have your own checksum generation and validation url set this here. Otherwise use the default Paytm urls
    mc.checksumGenerationURL = @"https://pguat.paytm.com/paytmchecksum/paytmCheckSumGenerator.jsp";
    mc.checksumValidationURL = @"https://pguat.paytm.com/paytmchecksum/paytmCheckSumVerify.jsp";
    
    //Step 3: Create the order with whatever params you want to add. But make sure that you include the merchant mandatory params
    NSMutableDictionary *orderDict = [NSMutableDictionary new];
    //Merchant configuration in the order object
    orderDict[@"MID"] = @"WorldP64425807474247";
    orderDict[@"CHANNEL_ID"] = @"WAP";
    orderDict[@"INDUSTRY_TYPE_ID"] = @"Retail";
    orderDict[@"WEBSITE"] = @"worldpressplg";
    //Order configuration in the order object
    orderDict[@"TXN_AMOUNT"] = @"1";
    orderDict[@"ORDER_ID"] = [HMPaytmViewController generateOrderIDWithPrefix:@""];
    orderDict[@"REQUEST_TYPE"] = @"DEFAULT";
    orderDict[@"CUST_ID"] = @"1234567890";
    
    PGOrder *order = [PGOrder orderWithParams:orderDict];
    
    //Step 4: Choose the PG server. In your production build dont call selectServerDialog. Just create a instance of the
    //PGTransactionViewController and set the serverType to eServerTypeProduction
    [PGServerEnvironment selectServerDialog:self.view completionHandler:^(ServerType type)
     {
         PGTransactionViewController *txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
         if (type != eServerTypeNone) {
             txnController.serverType = type;
             txnController.merchant = mc;
             txnController.delegate = self;
             [self showController:txnController];
         }
     }];
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
    if (!error) msg = [NSString stringWithFormat:@"Successful"];
    else msg = [NSString stringWithFormat:@"UnSuccessful"];
    
    [[[UIAlertView alloc] initWithTitle:@"Transaction Cancel" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self removeController:controller];
}

- (void)didFinishCASTransaction:(PGTransactionViewController *)controller response:(NSDictionary *)response
{
    DEBUGLOG(@"ViewController::didFinishCASTransaction:response = %@", response);
}

@end
