//
//  LocationView.h
//  Hunger Meals
//
//  Created by Vamsi on 01/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationTableViewCell.h"
#import "SVService.h"
#import "HMConstants.h"

@protocol LocationViewDelegate <NSObject>

- (void)selectedLocation:(NSDictionary *)location;
- (void)locationResponse:(NSString *)message;

@end

@interface LocationView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<LocationViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *instancesArray;
@property NSIndexPath *selectedIndexPath;
@property BOOL isLocalChange;
@property (weak, nonatomic)NSString * stringToDisplay;
@end
