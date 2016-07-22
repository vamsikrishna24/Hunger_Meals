//
//  ViewController.h
//  Hunger Meals
//
//  Created by Vamsi T on 08/07/2016.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import "MTGenericAlertView.h"

@interface LandingPageViewController : UIViewController<ECSlidingViewControllerDelegate, MTGenericAlertViewDelegate>

@property(nonatomic, weak) IBOutlet UIView *popUpBoxView;

- (IBAction)menuButtonTapped:(id)sender;

@end

