//
//  HMMonthlyDetailViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 18/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMMonthlyDetailViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UIPageControl* pageControl;

@end
