//
//  HMItemList.h
//  Hunger Meals
//
//  Created by Vamsi on 01/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTableViewCell.h"
#import "SVService.h"
#import "HMConstants.h"


@interface HMItemList : UIView<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *instancesArray;
@property NSIndexPath *selectedIndexPath;
@property BOOL isLocalChange;
@property (weak, nonatomic)NSString * stringToDisplay;
@end
