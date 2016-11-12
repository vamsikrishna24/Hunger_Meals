//
//  HMTabBarViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMTabBarViewController : UITabBarController<UITabBarDelegate,UIAlertViewDelegate,UITabBarControllerDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabbarView;

@end
