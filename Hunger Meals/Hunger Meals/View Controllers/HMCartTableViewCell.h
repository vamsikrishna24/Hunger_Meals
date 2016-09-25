//
//  HMCartTableViewCell.h
//  Hunger Meals
//
//  Created by Vamsi on 25/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMCartTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *stepperView;
@property (weak, nonatomic) IBOutlet UIImageView *cartItemsImageView;
@property (weak, nonatomic) IBOutlet UILabel *cartItemTitle;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *decrimentButton;
@property (weak, nonatomic) IBOutlet UIButton *incrementButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@end
