//
//  HMCartTableViewCell.m
//  Hunger Meals
//
//  Created by Vamsi on 25/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMCartTableViewCell.h"

@implementation HMCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.stepperView.layer.borderWidth = 1;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
