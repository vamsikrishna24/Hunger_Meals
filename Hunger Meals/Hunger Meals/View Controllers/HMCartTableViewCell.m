//
//  HMCartTableViewCell.m
//  Hunger Meals
//
//  Created by Vamsi on 25/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMCartTableViewCell.h"
#import "Product.h"
#import "SVService.h"
#import "ProjectConstants.h"

@implementation HMCartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //self.countLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.incrementButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.decrimentButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.stepperView.layer.borderWidth = 1;
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
    
    if ([self.countLabel.text intValue]>1){
        self.countLabel.text = [NSString stringWithFormat:@"%d",[self.countLabel.text intValue]-1];
    }
    
    APPDELEGATE.cartItemsValue--;
    [[APPDELEGATE.homeNavigationController.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%ld",(long)APPDELEGATE.cartItemsValue]];

    
}
@end
