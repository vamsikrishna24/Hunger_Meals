//
//  LocationsTableViewCell.m
//  Hunger Meals
//
//  Created by Vamsi on 09/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "LocationsTableViewCell.h"

@implementation LocationsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.addressTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 5, self.contentView.frame.size.width, 40)];
    self.addressTextView.textColor = [UIColor blackColor];
    self.addressTextView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.addressTextView];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
