//
//  HMSignUpPageViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 19/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMSignUpPageViewController : UIViewController<UIPageViewControllerDelegate,UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@end
