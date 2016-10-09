//
//  SlideMenuViewController.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 7/14/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMLandingViewController.h"
#import "UserData.h"
#import "BTAlertController.h"
#import "CommonViewController.h"
#import "SVService.h"
#import "MealsViewController.h"

@interface SlideMenuViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *profileView;
@property(strong,nonatomic)IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property NSUInteger pageIndex;

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;
@end
