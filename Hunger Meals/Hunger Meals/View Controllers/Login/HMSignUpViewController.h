//
//  HMSignUpViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 26/07/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGenericAlertView.h"
#import "CommonViewController.h"


@interface HMSignUpViewController : CommonViewController <MTGenericAlertViewDelegate>
@property(nonatomic, weak) IBOutlet UIButton *verficationBtn;

@end
