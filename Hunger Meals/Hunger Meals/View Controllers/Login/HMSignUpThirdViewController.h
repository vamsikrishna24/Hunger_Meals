//
//  HMSignUpThirdViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 20/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMSignUpThirdViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *addressTableView;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *addAddressButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *skipButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *saveButtonOutlet;
- (IBAction)addAddressAction:(id)sender;

- (IBAction)skipButtonAction:(id)sender;

- (IBAction)saveButtonAction:(id)sender;
@property NSUInteger pageIndex;
@end
