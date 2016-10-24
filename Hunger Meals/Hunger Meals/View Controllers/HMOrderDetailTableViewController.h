//
//  HMOrderDetailTableViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 10/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "OrderDetails.h"

@interface HMOrderDetailTableViewController : CommonViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *orderDetailsTableview;
@property (nonatomic, weak) IBOutlet UILabel *orderNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *orderDateLabel;
@property (nonatomic, strong) OrderDetails *orderDetail;
@end
