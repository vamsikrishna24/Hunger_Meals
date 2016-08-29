//
//  HMHomePageViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 06/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMHomePageViewController.h"
#import "HMLocationViewController.h"
#import "SlideMenuViewController.h"
#import "HMScrollingCell.h"
#import "HMCartViewController.h"

@interface HMHomePageViewController (){
    NSArray *categories;
    NSArray *categoriesImgs;
    NSArray *scrollingImgs;
    UIButton *floatingButton;
    
}

@end

@implementation HMHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.homePageTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    categories = [NSArray arrayWithObjects: @"Meals",@"Monthly Meal Planner",@"Store", nil];
    
    categoriesImgs = [NSArray arrayWithObjects: @"Category1.png",@"Category2.png",@"Category3.png", nil];
    
    scrollingImgs = [NSArray arrayWithObjects: @"page1.png",@"page2.png",@"page3.png",@"page4.png", @"page5.png", nil];
    
    //Menu open/close based on gesture recognizer
    SWRevealViewController *revealController = self.revealViewController;
    revealController.delegate = self;
    if (revealController)
    {
        [self.slideBarButton setTarget: self.revealViewController];
        [self.slideBarButton setAction: @selector( revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    }

    //Floating Button
    floatingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [floatingButton addTarget:self
                       action:@selector(floatingButtonClicked:)
             forControlEvents:UIControlEventTouchDown];
    [floatingButton setBackgroundImage:[UIImage imageNamed:@"Cart.png"] forState:UIControlStateNormal];
    floatingButton.frame = CGRectMake(self.view.frame.size.width/2-20, self.view.frame.size.height - 120, 60.0, 60.0);
    floatingButton.layer.cornerRadius = floatingButton.frame.size.width/2.0f;
    floatingButton.clipsToBounds = YES;
    [floatingButton addTarget:self action:@selector(cartView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:floatingButton];
}
-(void)cartView{
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HMCartViewController *cartViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CartViewIdentifier"];
    [self.navigationController pushViewController:cartViewController animated:YES];

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
    
    HMScrollingCell * cell = (HMScrollingCell*)[self.homePageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    cell.pageControl.currentPage = page;
    
    //    cell.titleLabel.text = [self.dashboardDataArray[sender.tag] objectForKey:kTitles][page] ;
    //    cell.descriptionLabel.text = [self.dashboardDataArray[sender.tag] objectForKey:kDescriptions] [page];
    
}

#pragma mark - Action methods
- (IBAction)changePage:(id)sender {
    UIPageControl *pageControl = (UIPageControl *)sender;
    NSInteger page = pageControl.currentPage;
    
    HMScrollingCell * selectedCell = (HMScrollingCell*)[self.homePageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:pageControl.tag inSection:0]];
    CGRect frame = selectedCell.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [selectedCell.scrollView scrollRectToVisible:frame animated:YES];
}

-(IBAction)floatingButtonClicked:(id)sender{
   //Floating Button Clicked
}
#pragma Mark - Custom Methods


#pragma Mark - TableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *scrollingCellIdentifier = @"ScrollingCellIdentifier";
    static NSString *categoryCellIdentifier = @"HomeCategoryIdentifier";
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        HMScrollingCell *scrollingCell = (HMScrollingCell *)[tableView dequeueReusableCellWithIdentifier:scrollingCellIdentifier];
        
        // Customize UIScrollView here..
        [scrollingCell.scrollView setDelegate:self];
        [scrollingCell.scrollView setPagingEnabled:YES];
        [scrollingCell.scrollView setTag:indexPath.row];
        [scrollingCell.scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollingCell.scrollView setUserInteractionEnabled:NO];
        [scrollingCell.contentView addGestureRecognizer:scrollingCell.scrollView.panGestureRecognizer];
        
        scrollingCell.pageControl.numberOfPages = [scrollingImgs count];
        [scrollingCell.pageControl setTag:indexPath.row];
        scrollingCell.pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DotInactive"]];
        
        scrollingCell.pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DotActive"]];
        
        NSArray *cellGallary = scrollingImgs;
        
        scrollingCell.scrollView.contentSize = CGSizeMake(scrollingCell.scrollView.frame.size.width * cellGallary.count,scrollingCell.scrollView.frame.size.height);
        
        for (int i = 0; i < cellGallary.count; i++) {
            CGRect frame;
            frame.origin.x = scrollingCell.scrollView.frame.size.width * i;
            frame.origin.y = 0;
            frame.size = scrollingCell.scrollView.frame.size;
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
            imageView.image = [UIImage imageNamed:cellGallary[i]];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            
            
            [scrollingCell.scrollView addSubview:imageView];
        }
        
        //configure cell
//        scrollingCell.titleLabel.text = [[self.dashboardDataArray[indexPath.row] objectForKey:kTitles] firstObject];

        
        return scrollingCell;
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:categoryCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:categoryCellIdentifier];
        }
        
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        imageView.image = [UIImage imageNamed:categoriesImgs[indexPath.row-1]];
        
        UILabel *categoryLabel = (UILabel *)[cell viewWithTag:2];
        categoryLabel.text = [categories objectAtIndex:indexPath.row-1];
        
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {
        UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HMCartViewController *cartViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MealsViewIdentifier"];
        [self.navigationController pushViewController:cartViewController animated:YES];

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 210;
    }
    CGRect deviceFrame = DEVICEFRAME;
    CGFloat height = deviceFrame.size.height;
    
    return (height-270)/3;
}

- (IBAction)menuButtonTapped:(id)sender {

}

- (IBAction)locationButtonTapped:(id)sender {
    
//    HMNotificationsViewController *notificationVC = [[HMNotificationsViewController alloc] init];
//    [self presentViewController:notificationVC animated:YES completion:nil];
    
}

- (IBAction)notificationButtonPressed:(id)sender {
}

#pragma Mark - SWRevealViewController delegate methods
- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    self.homePageTableView.userInteractionEnabled =
    (revealController.frontViewPosition == FrontViewPositionRight ? FALSE : TRUE);
}
@end
