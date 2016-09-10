//
//  HMCartViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 25/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface HMCartViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)IBOutlet UITableView *cartTableView;
@end
