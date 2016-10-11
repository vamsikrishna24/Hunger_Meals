//
//  PayTMViewController.h
//  Hunger Meals
//
//  Created by Uber - Sivajee Battina on 09/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentsSDK.h"

@interface PayTMViewController : UIViewController <PGTransactionDelegate>
@property (nonatomic,strong)NSString *paymentString;
@end
