//
//  SlideMenuViewController.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 7/14/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(strong,nonatomic)IBOutlet UIImageView *profileImageView;
- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;
@end
