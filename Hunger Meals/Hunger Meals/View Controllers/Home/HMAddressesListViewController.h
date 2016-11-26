//
//  HMAddressesListViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 26/11/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGenericAlertView.h"
#import "CommonViewController.h"

@interface HMAddressesListViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *addressesTableView;
@property NSMutableArray *addressesArray;
@property NSString *priceString;


@end
