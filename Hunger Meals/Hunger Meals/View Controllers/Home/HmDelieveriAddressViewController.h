//
//  HmDelieveriAddressViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 13/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface HmDelieveriAddressViewController : CommonViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *homeButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *officeButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *otherButtonOutlet;
@property (weak, nonatomic) IBOutlet UITextField *pinCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *deliveryAddressTextFiels;
@property (weak, nonatomic) IBOutlet UITextField *flatNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaLocalityTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateTextField;
@property (weak, nonatomic) IBOutlet UIButton *proceedToCheckOutButtonOutlet;
@property(nonatomic,strong) NSString *PaymentAmountString;

- (IBAction)proceedToCheckoutAction:(id)sender;

@end
