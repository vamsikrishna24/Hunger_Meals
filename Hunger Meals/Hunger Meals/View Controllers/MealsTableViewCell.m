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
- (IBAction)addAction:(id)sender{
    
        self.countLabel.text = [NSString stringWithFormat:@"%d",[self.countLabel.text intValue]+1];

}
- (IBAction)decrementAction:(id)sender {
     self.countLabel.text = [NSString stringWithFormat:@"%d",[self.countLabel.text intValue]-1];

}
- (IBAction)addTocartButtonAction:(id)sender {
     self.addToCartButton.hidden = YES;
}


@end
