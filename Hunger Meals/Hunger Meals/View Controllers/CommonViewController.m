//
//  CommonViewController.m
//  SmartVijayawada
//
//  Created by SivajeeBattina on 12/14/15.
//  Copyright © 2015 Paradigmcreatives. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()
    
@property (nonatomic, strong) MBProgressHUD* hud;
@property (nonatomic, assign, getter=isIndicatorShowing) BOOL activityIndicatorIsShowing;

@end

@implementation CommonViewController

@synthesize hud, activityIndicatorIsShowing;

- (void) viewDidLoad {
    [super viewDidLoad];
    [self initializations];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
    [self.navigationController.navigationBar setTintColor:APPLICATION_COLOR];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self prepareNavigationBarUI];
    
    //status bar color
    [self setStatusBarBackgroundColor:[UIColor colorWithRed:234/255.0f green:90/255.0f blue:51/255.0f alpha:1.0f]];
}

- (void) initializations{
    hud = [[MBProgressHUD alloc] initWithView:self.view];

}

- (void) prepareNavigationBarUI {
    
//    navigationItem.titleAlignment = NSTextAlignmentCenter;
//    navigationItem.titleColor = [UIColor whiteColor];
//    navigationTitleLabel.font = [Fonts fontHelveticaWithSize:19.0];
//    self.navigationItem.titleView = navigationTitleLabel;

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:238.0/255.0f green:238.0/255.0f blue:238.0/255.0f alpha:1.0f];

    
    if (IDIOM == IPAD) {
         self.navigationController.navigationBar.titleTextAttributes = @{
                                                                NSForegroundColorAttributeName:APPLICATION_TITLE_COLOR ,
                                                                NSFontAttributeName: [Fonts nevisWithSize:23.0]
                                                                };
    }
    else{
        self.navigationController.navigationBar.titleTextAttributes =
        @{
                                                                NSForegroundColorAttributeName: APPLICATION_TITLE_COLOR,
                                                                NSFontAttributeName: [Fonts nevisWithSize:18.0]
                                                                };
    }
    

    if ([NSStringFromClass([self class]) isEqualToString:@"HMHomePageViewController"]) {
        self.navigationItem.title = @"Hunger Meals";
    
    }else if ([NSStringFromClass([self class]) isEqualToString:@"HMSignUpViewController"]) {
        self.navigationItem.title = @"Sign Up";

    }
    else if ([NSStringFromClass([self class]) isEqualToString:@"MealsViewController"]) {
        self.navigationItem.title = @"Menu";
    }
    
}

- (void)addBackButtonToNavigation{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self.navigationController
                                                                  action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.leftBarButtonItem.tintColor = APPLICATION_COLOR;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setStatusBarBackgroundColor:(UIColor *)color {
    
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

#pragma -mark MBHUD ProgressView methods

- (void) showActivityIndicator: (NSString *) title {
    // The hud will disable all input on the view
    hud.opacity = 1.0f;
    
    if(title != nil) {
        hud.label.text = title;
    }
    
    // Add HUD to screen
    [self.view addSubview:hud];
    
    // Register for HUD callbacks so we can remove it from the window at the right time
    hud.delegate = self;
    [hud showAnimated:YES];
    [self setActivityIndicatorIsShowing:YES];
}

- (void) showActivityIndicatorWithTitle: (NSString *) title {
    
    //only ever show one HUD at a time
    if(!activityIndicatorIsShowing) {
        //Showing the activity indicator must be on the main thread.
        [self performSelectorOnMainThread:@selector(showActivityIndicator:) withObject:title waitUntilDone:NO];
    }
}

- (void) hideActivityIndicatorT {
    if(activityIndicatorIsShowing){
        [self hudWasHidden];
        [self setActivityIndicatorIsShowing:NO];
    }
}

- (void) hideActivityIndicator {
    //Hiding the activity indicator must be on the main thread.
    [self performSelectorOnMainThread:@selector(hideActivityIndicatorT) withObject:nil waitUntilDone:NO];
}

- (void) hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
}

@end
