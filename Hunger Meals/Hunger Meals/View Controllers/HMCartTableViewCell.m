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
- (IBAction)addAction:(id)sender{
    
    self.countLabel.text = [NSString stringWithFormat:@"%d",[self.countLabel.text intValue]+1];
//    
//    //UIButton *btn = (UIButton *)sender;
//    Product *productObject = [[Product alloc]init];
//    //Product *productObject = cartItemsArray[btn.tag];
//    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: productObject.id, @"inventories_id",@"1", @"quantity",  nil];
//    SVService *service = [[SVService alloc] init];
//    [service addToCart:dict usingBlock:^(NSString *resultMessage) {
//        if (resultMessage != nil) {
//            
//        }
//    }];

    
}
- (IBAction)decrementAction:(id)sender {
    self.countLabel.text = [NSString stringWithFormat:@"%d",[self.countLabel.text intValue]-1];
    
}
@end
