//
//  MealsTableViewCell.m
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "MealsTableViewCell.h"
#import "HMConstants.h"

@implementation MealsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.decrementButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.incrementButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)addAction:(id)sender{
    self.countLabel.text = [NSString stringWithFormat:@"%d",[self.countLabel.text intValue]+1];
    
    APPDELEGATE.cartItemsValue++;
    [[APPDELEGATE.homeNavigationController.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld",(long)APPDELEGATE.cartItemsValue]];
    
}
- (IBAction)decrementAction:(id)sender {
    if ([self.countLabel.text intValue]<=1) {
         self.addToCartButton.hidden = NO;
    }
    else{
    self.countLabel.text = [NSString stringWithFormat:@"%d",[self.countLabel.text intValue]-1];
    }
    
    APPDELEGATE.cartItemsValue--;
    [[APPDELEGATE.homeNavigationController.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld",(long)APPDELEGATE.cartItemsValue]];

}
- (IBAction)addTocartButtonAction:(id)sender {
        APPDELEGATE.cartItemsValue++;
        [[APPDELEGATE.homeNavigationController.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld",(long)APPDELEGATE.cartItemsValue]];

     self.addToCartButton.hidden = YES;
}


@end
