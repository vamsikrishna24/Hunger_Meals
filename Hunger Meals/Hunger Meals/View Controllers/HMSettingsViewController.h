//
//  HMSettingsViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 05/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface HMSettingsViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userEmailLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNumberLabel;

@end
