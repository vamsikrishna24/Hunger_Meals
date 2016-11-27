//
//  HMPaymentTypeSelectionViewController.h
//  Hunger Meals
//
//  Created by Vamsi T on 28/07/2016.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentsSDK.h"



@interface HMPaymentTypeSelectionViewController : UIViewController<PGTransactionDelegate>

@property (nonatomic, weak) IBOutlet UIButton *paytmButton;
@property (nonatomic, weak) IBOutlet UIButton *payUButton;
@property (weak, nonatomic) IBOutlet UIButton *codButton;
@property(nonatomic,strong) NSString *PaymentAmountString;
@property(nonatomic,strong) NSString *addressString;
@property(nonatomic)double latitude;
@property(nonatomic)double longitude;


@end
