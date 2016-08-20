//
//  HMSignUpFirstViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 20/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMSignUpFirstViewController : UIViewController<UITextFieldDelegate>
@property NSUInteger pageIndex;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *paswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButtonOutlet;

@property(strong,nonatomic) UIPageViewController *pageViewController;

- (IBAction)nextButtonAction:(id)sender;
@end
