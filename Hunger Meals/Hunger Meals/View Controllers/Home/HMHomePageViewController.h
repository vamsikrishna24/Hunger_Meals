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
#import <CoreLocation/CoreLocation.h>
#import "LocationTableViewCell.h"
#import "LocationView.h"
//#import "PCSAlertViewContainer.h"


@interface HMHomePageViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate, SWRevealViewControllerDelegate,MTGenericAlertViewDelegate,UIPopoverPresentationControllerDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate, LocationViewDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *locationBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *homePageTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *notificationsBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *slideBarButton;
@property (strong, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UITableView *locationTableView;

@property (strong, nonatomic) IBOutlet UIView *addressView;

@property (weak, nonatomic) IBOutlet LocationView *instanceView;
//@property PCSAlertViewContainer *selectInstancePopUp;

- (IBAction)menuButtonTapped:(id)sender;

@end
