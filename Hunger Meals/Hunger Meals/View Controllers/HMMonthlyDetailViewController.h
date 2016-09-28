//
//  HMMonthlyDetailViewController.h
//  Hunger Meals
//
//  Created by Vamsi on 18/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"
#import "CommonViewController.h"

@interface HMMonthlyDetailViewController :CommonViewController <UIScrollViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,SwipeViewDataSource,SwipeViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *imagesCollectionView;
@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl* pageControl;
@property (nonatomic, weak) IBOutlet SwipeView *swipeView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign, getter = isPagingEnabled) BOOL pagingEnabled;


- (IBAction)pagingAction:(id)sender;



@end
