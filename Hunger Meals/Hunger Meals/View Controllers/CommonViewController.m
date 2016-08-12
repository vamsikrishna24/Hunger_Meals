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

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self prepareNavigationBarUI];
}

- (void) initializations{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
}

- (void) prepareNavigationBarUI {
    
//    navigationItem.titleAlignment = NSTextAlignmentCenter;
//    navigationItem.titleColor = [UIColor whiteColor];
//    navigationTitleLabel.font = [Fonts fontHelveticaWithSize:19.0];
//    self.navigationItem.titleView = navigationTitleLabel;

    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];

    
    if (IDIOM == IPAD) {
         self.navigationController.navigationBar.titleTextAttributes = @{
                                                                NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                NSFontAttributeName: [Fonts fontHelveticaWithSize:26.0]
                                                                };
    }
    else{
        self.navigationController.navigationBar.titleTextAttributes =
        @{
                                                                NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                NSFontAttributeName: [Fonts fontHelveticaWithSize:19.0]
                                                                };
    }
    

    if ([NSStringFromClass([self class]) isEqualToString:@"HMHomePageViewController"]) {
        self.navigationItem.title = @"Hunger Meals";
    
    }else if ([NSStringFromClass([self class]) isEqualToString:@"HMSignUpViewController"]) {
        self.navigationItem.title = @"Sign Up";
        

    }
    
}

- (void)addBackButtonToNavigation{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Button"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self.navigationController
                                                                  action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)addBackButtonToNewsEvents{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Button"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self.navigationController
                                                                  action:@selector(popToRootViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = backButton;
}
#pragma -mark MBHUD ProgressView methods
- (void) showActivityIndicator: (NSString *) title {
    // The hud will disable all input on the view
    hud.opacity = 0.7f;
    
    if(title != nil) {
        [hud setLabelText:title];
    }
    
    // Add HUD to screen
    [self.view addSubview:hud];
    
    // Register for HUD callbacks so we can remove it from the window at the right time
    hud.delegate = self;
    [hud show:YES];
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
