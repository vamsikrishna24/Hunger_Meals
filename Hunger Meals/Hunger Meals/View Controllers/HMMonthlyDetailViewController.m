//
//  HMMonthlyDetailViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 18/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMMonthlyDetailViewController.h"
#import "HMMonthlyCollectionViewCell.h"

@interface HMMonthlyDetailViewController ()<UIScrollViewDelegate>{
    NSArray *scrollingImgs;

}

@end

@implementation HMMonthlyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollingImgs = [NSArray arrayWithObjects: @"page1.png",@"page2.png",@"page3.png",@"page4.png", @"page5.png", nil];

    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setUserInteractionEnabled:NO];
    [self.view addGestureRecognizer:self.scrollView.panGestureRecognizer];
    self.pageControl.numberOfPages = [scrollingImgs count];
//    [self.pageControl setTag:0];
    // scrollingCell.pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DotInactive"]];
    
    //scrollingCell.pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DotActive"]];
    
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
    [self.collectionView setCollectionViewLayout:self.flowLayout];
    self.collectionView.bounces = YES;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];

    // Do any additional setup after loading the view.
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
    
    //    cell.titleLabel.text = [self.dashboardDataArray[sender.tag] objectForKey:kTitles][page] ;
    //    cell.descriptionLabel.text = [self.dashboardDataArray[sender.tag] objectForKey:kDescriptions] [page];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)vegNonveg{
    NSArray *imgNames = [[NSArray alloc] initWithObjects:@"page1.png",@"page2.png",@"page3.png",@"page4.png", @"page5.png", nil];

    
    // Setup the array of UIImageViews
    NSMutableArray *imgArray = [[NSMutableArray alloc] init];
    UIImageView *tempImageView;
    for(NSString *name in imgNames) {
        tempImageView = [[UIImageView alloc] init];
        tempImageView.contentMode = UIViewContentModeScaleAspectFit;
        tempImageView.image = [UIImage imageNamed:name];
        [imgArray addObject:tempImageView];
        
    }
    
    CGSize pageSize = _scrollView.frame.size; // scrollView is an IBOutlet for our UIScrollView
    NSUInteger page = 0;
    for(UIView *view in imgArray) {
        [_scrollView addSubview:view];
        
        // This is the important line
        view.frame = CGRectMake(pageSize.width * page++ + 10, 0, pageSize.width - 20, pageSize.height);
        // We're making use of the scrollView's frame size (pageSize) so we need to;
        // +10 to left offset of image pos (1/2 the gap)
        // -20 for UIImageView's width (to leave 10 gap at left and right)
    }
    
    _scrollView.contentSize = CGSizeMake(pageSize.width * [imgArray count], pageSize.height);
}

#pragma mark - Collection View Delegate methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"collectionCustomcell";
    
    HMMonthlyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageNamed:[scrollingImgs objectAtIndex:indexPath.row]];
    
    return cell;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10; // This is the minimum inter item spacing, can be more
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
