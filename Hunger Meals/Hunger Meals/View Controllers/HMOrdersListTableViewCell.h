//
//  HMOrdersListTableViewCell.h
//  Hunger Meals
//
//  Created by Vamsi on 09/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMOrdersListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *ItemNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *viewDetailsButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;

@end
