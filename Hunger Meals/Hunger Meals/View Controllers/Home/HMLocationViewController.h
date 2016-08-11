//
//  HMLocationViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 09/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface HMLocationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UIView *notificationsViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeBarButton;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UITableView *notificationsTableView;
@property (weak, nonatomic) IBOutlet UILabel *locatinLabel;


@end
