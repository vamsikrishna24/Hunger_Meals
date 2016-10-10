//
//  HMOrdersListTableViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 09/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface HMOrdersListTableViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ordersTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButtonItem;
- (IBAction)closeAction:(id)sender;
- (IBAction)viewDetailsButtonAction:(id)sender;

@end
