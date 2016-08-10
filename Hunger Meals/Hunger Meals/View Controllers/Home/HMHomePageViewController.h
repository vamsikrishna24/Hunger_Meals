//
//  HMHomePageViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 06/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

@interface HMHomePageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, ECSlidingViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *locationBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *homePageTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *notificationsBarButtonItem;

- (IBAction)menuButtonTapped:(id)sender;

@end
