//
//  QuickbitesViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "Utility.h"

@interface QuickbitesViewController : CommonViewController
- (IBAction)nonVegetarianAction:(id)sender;

- (IBAction)vegetarianAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nonVegetarianButtonOutlet;

@property (weak, nonatomic) IBOutlet UIButton *vegetarianButtonOutlet;
@end
