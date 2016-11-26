//
//  HMAddressesCell.h
//  Hunger Meals
//
//  Created by Vamsi on 26/11/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMAddressesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *radioButtonImageView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (nonatomic,assign) BOOL isRadioButtonSelected;
@property (nonatomic,assign) NSInteger selectedRow;


@end
