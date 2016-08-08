//
//  HMHomePageViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 06/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMHomePageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *homePageTableView;
@end
