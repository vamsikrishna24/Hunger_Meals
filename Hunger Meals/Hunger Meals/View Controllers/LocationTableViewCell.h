//
//  LocationTableViewCell.h
//  Hunger Meals
//
//  Created by Vamsi on 01/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *radioButton;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationLeadingConstraint;

@end
