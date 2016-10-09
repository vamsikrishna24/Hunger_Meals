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

@end
