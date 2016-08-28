//
//  MealsTableViewCell.m
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "MealsTableViewCell.h"

@implementation MealsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addToCartAction:(id)sender {
    self.addToCartButton.hidden = YES;
    self.stepperView.hidden = NO;
}
@end
