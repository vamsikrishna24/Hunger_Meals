//
//  PaymentStatusViewController.m
//  PaymentGateway
//
//  Created by Suraj on 30/07/15.
//  Copyright (c) 2015 Suraj. All rights reserved.
//

#import "PaymentStatusViewController.h"

@interface PaymentStatusViewController () {
    __weak IBOutlet UITextField *txtFieldProductInfo;
    __weak IBOutlet UITextField *txtFieldTransactionStatus;
    __weak IBOutlet UITextField *txtFieldTransactionID;
}

- (IBAction)popToPaymentPage:(id)sender;

@end

@implementation PaymentStatusViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self setTitle:@"Payment Status"];
    self.navigationItem.hidesBackButton = YES;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self setTitle:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUserDataToUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUserDataToUI {
    [txtFieldProductInfo setText:[self.mutDictTransactionDetails objectForKey:@"Product_Info"]];
    [txtFieldTransactionStatus setText:[self.mutDictTransactionDetails objectForKey:@"Transaction_Status"]];
    [txtFieldTransactionID setText:[self.mutDictTransactionDetails objectForKey:@"Transaction_ID"]];
}

- (IBAction)popToPaymentPage:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}
@end
