//
//  HMSignUpThirdViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 20/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface HMSignUpThirdViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource>

@property NSString *email;
@property NSString *password;
@property NSString *phoneNumber;
@property(strong,nonatomic) UIPageViewController *pageViewController;

@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *addAddressButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *skipButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *saveButtonOutlet;
- (IBAction)addAddressAction:(id)sender;

- (IBAction)skipButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

@end
