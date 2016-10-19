//
//  HMComboSelectionViewController.h
//  Hunger Meals
//
//  Created by Uber - Sivajee Battina on 19/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMComboSelectionViewController : UIViewController

@property (nonatomic, strong) NSString *selectedCombo;
@property (nonatomic, strong) IBOutlet UIButton *northIndianBtn;
@property (nonatomic, strong) IBOutlet UIButton *southIndianBtn;
@property (nonatomic, strong) IBOutlet UIButton *lunchCheckBox;
@property (nonatomic, strong) IBOutlet UIButton *dinnerCheckBox;


@end
