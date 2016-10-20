//
//  HMMonthlyCartViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 25/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface HMMonthlyCartViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIButton *makePaymentButton;
@property (weak, nonatomic) IBOutlet UITextField *promoCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *promoCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *packagingValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *dekieveryChagesValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *cessValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *vatValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTaxValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceChargeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *packagingChargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *delieveryChargesLabel;
@property(nonatomic,strong)IBOutlet UITableView *cartTableView;
@property (weak, nonatomic) IBOutlet UILabel *serviceChargeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cessLabel;
@property (weak, nonatomic) IBOutlet UILabel *vatLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTaxLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountDiscountLabel;
- (IBAction)applyButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic)  NSString *quantityString;


@end
