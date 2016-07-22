//
//  ViewController.m
//  Hunger Meals
//
//  Created by Vamsi T on 08/07/2016.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "LandingPageViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface LandingPageViewController ()

@end

@implementation LandingPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Menu open/close based on gesture recognizer
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    [self.slidingViewController.topViewController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    //Showing popup at intial
    [self showPopUpBoxAtStartUp];
}

//**********************************
#pragma mark - Action Methods
//**********************************

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

-(void)showPopUpBoxAtStartUp{
    MTGenericAlertView *alertView = [[MTGenericAlertView alloc] initWithTitle:@"Pick Up Your City" titleColor:[UIColor whiteColor] titleFont:nil backgroundImage:nil];
    
    //Add close button only to handle close button action. Other wise by default close button will be added.
    alertView.popUpCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [alertView.popUpCloseButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [alertView setCustomInputView:_popUpBoxView];
    alertView.isPopUpView = YES;
    [alertView setDelegate:self];
    [alertView show];

}
@end
