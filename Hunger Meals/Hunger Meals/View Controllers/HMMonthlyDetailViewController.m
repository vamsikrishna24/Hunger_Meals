//
//  HMMonthlyDetailViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 18/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMMonthlyDetailViewController.h"
#import "HMMonthlyCollectionViewCell.h"
#import "HMScrollMonthlyCollectionViewCell.h"

@interface HMMonthlyDetailViewController ()<UIScrollViewDelegate,UIScrollViewAccessibilityDelegate>{
    NSArray *scrollingImgs;

}

@end

@implementation HMMonthlyDetailViewController

- (void)awakeFromNib
{
    //set up data
    //your swipeView should always be driven by an array of
    //data of some kind - don't store data in your item views
    //or the recycling mechanism will destroy your data once
    //your item views move off-screen
    scrollingImgs = [NSArray arrayWithObjects: @"page1.png",@"page2.png",@"page3.png",@"page4.png", @"page5.png", nil];
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+500);
    _scrollView.bounces = NO;


   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _swipeView.pagingEnabled = YES;

    self.pageControl.currentPage = 0;

    //collection view flowlayout
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    self.pageControl.currentPage = self.swipeView.currentItemIndex;
    CGSize scrollableSize = CGSizeMake(320, 800);
    [self.scrollView setContentSize:scrollableSize];
}
#pragma mark - ScrollView Delegate methods
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Collection View Delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if(collectionView == self.collectionView){
        return 5;
    }
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"collectionCustomcell";
    static NSString *identifier1 = @"offersCollectionCustomcell";

    if(collectionView == self.collectionView){
    
    HMMonthlyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:[scrollingImgs objectAtIndex:indexPath.row]];
        cell.contentView.layer.masksToBounds = true;
        return cell;

    }
    HMScrollMonthlyCollectionViewCell*imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier1 forIndexPath:indexPath];
    
    imageCell.imageView.image = [UIImage imageNamed:[scrollingImgs objectAtIndex:indexPath.row]];
    imageCell.contentView.layer.masksToBounds = true;
    return imageCell;

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0; // This is the minimum inter item spacing, can be more
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    //return the total number of items in the carousel
    return [scrollingImgs count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIImageView *imageView = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {

        view = [[UIView alloc] initWithFrame:self.swipeView.bounds];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = 1;
        [view addSubview:imageView];
    }
    else
    {
        //get a reference to the label in the recycled view
        imageView = (UIImageView *)[view viewWithTag:1];
    }
    

    imageView.image = [UIImage imageNamed:scrollingImgs[index]];
    return view;
}

- (void)swipeViewDidEndDecelerating:(SwipeView *)swipeView{
    self.pageControl.currentPage = self.swipeView.currentItemIndex;

}


- (CGSize)swipeViewItemSize:(SwipeView *)swipeView
{
    return self.swipeView.bounds.size;
}
- (IBAction)pagingAction:(id)sender {
    self.swipeView.currentItemIndex = self.pageControl.currentPage;
    self.swipeView.currentPage = self.pageControl.currentPage;
}


@end
