//
//  HMScrollingCell.m
//  Hunger Meals
//
//  Created by SivajeeBattina on 8/24/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMScrollingCell.h"

@implementation HMScrollingCell
@synthesize scrollView, pageControl;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
