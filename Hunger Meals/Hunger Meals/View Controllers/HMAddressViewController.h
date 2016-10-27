//
//  HMAddressViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 07/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "MTGenericAlertView.h"


@interface HMAddressViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,MTGenericAlertViewDelegate>
@property NSMutableArray *addressesArray;

@end
