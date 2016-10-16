//
//  HMItemListTableViewCell.h
//  Hunger Meals
//
//  Created by Vamsi on 03/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMItemListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *lunchButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *dinnerButtonOutlet;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;

@end
