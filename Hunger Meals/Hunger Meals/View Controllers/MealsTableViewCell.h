//
//  MealsTableViewCell.h
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MealsTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *itemImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextView *descriptionView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIButton *addToCartButton;
@property (weak, nonatomic) IBOutlet UIView *stepperView;
@property (weak, nonatomic) IBOutlet UIButton *decrementButton;
@property (weak, nonatomic) IBOutlet UIButton *incrementButton;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *vegNonVegColorView;
@property (weak, nonatomic) IBOutlet UIImageView *vegImageView;

@end
