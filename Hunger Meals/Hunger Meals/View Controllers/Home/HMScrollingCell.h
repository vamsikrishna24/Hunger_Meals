//
//  HMScrollingCell.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 8/24/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HMScrollingCell : UITableViewCell
{
    UIPageControl* pageControl;
    UIScrollView* scrollView;
    BOOL pageControlBeingUsed;
}

@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;

@property (nonatomic, strong) IBOutlet UIPageControl* pageControl;

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end
