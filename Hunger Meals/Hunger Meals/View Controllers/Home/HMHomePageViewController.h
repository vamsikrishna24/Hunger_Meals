//
//  HMHomePageViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 06/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "MTGenericAlertView.h"



@interface HMHomePageViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate, SWRevealViewControllerDelegate,MTGenericAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *locationBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *homePageTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *notificationsBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideBarButton;

@property (strong, nonatomic) IBOutlet UIView *addressView;

- (IBAction)menuButtonTapped:(id)sender;

@end
