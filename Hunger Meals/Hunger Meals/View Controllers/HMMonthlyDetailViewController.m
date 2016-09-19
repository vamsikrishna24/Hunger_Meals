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

@interface HMMonthlyDetailViewController ()<UIScrollViewDelegate>{
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

   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _swipeView.pagingEnabled = YES;
    
    NSArray *cellGallary = scrollingImgs;

    for (int i = 0; i < cellGallary.count; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageNamed:cellGallary[i]];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 5, self.scrollView.frame.size.height);
    [self.scrollView setDelegate:self];
    self.pageControl.currentPage = 0;

    //collection view flowlayout
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    // Configure layout
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [self.flowLayout setItemSize:CGSizeMake(211, 150)];
    [self.flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    self.flowLayout.minimumInteritemSpacing = 10.0f;
    
    self.pageControl.currentPage = self.swipeView.currentItemIndex;

}
#pragma mark - ScrollView Delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    CGFloat xOffset = sender.contentOffset.x;
    CGFloat frameWidth = sender.frame.size.width;
    
    if (xOffset<0) {
        [sender setContentOffset:CGPointZero animated:NO];
    }
    else if (xOffset>sender.contentSize.width-frameWidth){
        [sender setContentOffset:CGPointMake(sender.contentSize.width-frameWidth, 0) animated:NO];
    }
    int page = floor((xOffset - frameWidth / 2) / frameWidth) + 1;
    self.pageControl.currentPage = page;
    
}
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
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
        //don't do anything specific to the index within
        //this `if (view == nil) {...}` statement because the view will be
        //recycled and used with other index values later
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
