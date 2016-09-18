//
//  HMMonthlyDetailViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 18/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMMonthlyDetailViewController.h"

@interface HMMonthlyDetailViewController (){
    NSArray *scrollingImgs;

}

@end

@implementation HMMonthlyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollingImgs = [NSArray arrayWithObjects: @"page1.png",@"page2.png",@"page3.png",@"page4.png", @"page5.png", nil];
    self.pageControl.numberOfPages = [scrollingImgs count];
    [self.scrollView setDelegate:self];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setTag:self.pageControl.tag];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setUserInteractionEnabled:NO];
    [self.scrollView addGestureRecognizer:self.scrollView.panGestureRecognizer];
    
    self.pageControl.numberOfPages = [scrollingImgs count];
    [self.pageControl setTag:self.scrollView.tag];

    
    NSArray *cellGallary = scrollingImgs;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * cellGallary.count,self.scrollView.frame.size.height);
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
