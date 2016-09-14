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
#import "HMContentViewController.h"


@interface HMHomePageViewController (){
    NSArray *categories;
    NSArray *categoriesImgs;
    NSArray *scrollingImgs;
    UIButton *floatingButton;
    MTGenericAlertView *locationPopup;
    
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
   // [self.view addSubview:floatingButton];
    
    //[self showPopUpBoxAtStartUp];


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
       // scrollingCell.pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DotInactive"]];
        
        //scrollingCell.pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DotActive"]];
        
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
        
        //set background color for mask view
        UIView *maskView = (UIView *)[cell viewWithTag:111];
        if (indexPath.row == 1) {
            [maskView setBackgroundColor:[UIColor colorWithRed:235/255.0f green:111/255.0f blue:56/255.0f alpha:0.5]];
        }
        else if (indexPath.row == 2){
            [maskView setBackgroundColor:[UIColor colorWithRed:171/255.0f green:212/255.0f blue:113/255.0f alpha:0.8]];
        }
        else if (indexPath.row == 3){
            [maskView setBackgroundColor:[UIColor colorWithRed:54/255.0f green:167/255.0f blue:181/255.0f alpha:0.8]];
        }
        else{
            [maskView setBackgroundColor:[UIColor clearColor]];
        }
        
        //Making selection style none
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView setLayoutMargins:UIEdgeInsetsMake(15, 0, 0, 0)];
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
        return 190;
    }
    CGRect deviceFrame = DEVICEFRAME;
    CGFloat height = deviceFrame.size.height;
    
    return (height-270)/3;
}

- (IBAction)menuButtonTapped:(id)sender {

}

- (IBAction)locationButtonTapped:(id)sender {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HMContentViewController *contentVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
        contentVC.view.backgroundColor = [UIColor clearColor];
        contentVC.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *popPC = contentVC.popoverPresentationController;
        popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
        popPC.delegate = self;
        popPC.barButtonItem = sender;
    CGSize finalDesiredSize = CGSizeMake(320, 190);
    
    CGSize tempSize = CGSizeMake(finalDesiredSize.width, finalDesiredSize.height + 1);
    [contentVC setPreferredContentSize:tempSize];
    [contentVC setPreferredContentSize:finalDesiredSize];
    UILabel *locationTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, contentVC.view.frame.size.width-10, 30)];
    locationTitleLabel.text = @"Enter your location";
    locationTitleLabel.textColor = [UIColor darkGrayColor];
    locationTitleLabel.font = [UIFont systemFontOfSize:13];
    [contentVC.view addSubview:locationTitleLabel];
    
    UILabel *separator1 = [[UILabel alloc]initWithFrame:CGRectMake(12, locationTitleLabel.frame.origin.y+locationTitleLabel.frame.size.height, locationTitleLabel.frame.size.width-70, 1)];
    separator1.backgroundColor = [UIColor lightGrayColor];
    [contentVC.view addSubview:separator1];
    
    UIButton *locationGPSButton = [[UIButton alloc]initWithFrame:CGRectMake(10,separator1.frame.origin.y+6, contentVC.view.frame.size.width-10, 30)];
    [locationGPSButton setTitle:@"Let us Locate you?" forState:UIControlStateNormal];
    [locationGPSButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    locationGPSButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    locationGPSButton.titleLabel.font = [UIFont systemFontOfSize:12];
    locationGPSButton.imageView.image = [UIImage imageNamed:@"edit"];

    [contentVC.view addSubview:locationGPSButton];

    UILabel *separator2 = [[UILabel alloc]initWithFrame:CGRectMake(12, locationGPSButton.frame.origin.y+locationGPSButton.frame.size.height, locationGPSButton.frame.size.width-70, 1)];
    separator2.backgroundColor = [UIColor lightGrayColor];
    [contentVC.view addSubview:separator2];
    
    UILabel *home = [[UILabel alloc]initWithFrame:CGRectMake(12, separator2.frame.origin.y+6, 70, 30)];
    home.text = @"Home";
    home.textColor = [UIColor orangeColor];
    home.font =  [UIFont systemFontOfSize:12];
    [contentVC.view addSubview:home];
    
    UILabel *separator3 = [[UILabel alloc]initWithFrame:CGRectMake(12, home.frame.origin.y+home.frame.size.height, locationGPSButton.frame.size.width-70, 1)];
    separator3.backgroundColor = [UIColor lightGrayColor];
    [contentVC.view addSubview:separator3];
    
    UILabel *office = [[UILabel alloc]initWithFrame:CGRectMake(12, separator3.frame.origin.y+6, 70, 30)];
    office.text = @"Office";
    office.textColor = [UIColor orangeColor];
    office.font =  [UIFont systemFontOfSize:12];
    [contentVC.view addSubview:office];
    
    UILabel *separator4 = [[UILabel alloc]initWithFrame:CGRectMake(12, office.frame.origin.y+office.frame.size.height, locationGPSButton.frame.size.width-70, 1)];
    separator4.backgroundColor = [UIColor lightGrayColor];
    [contentVC.view addSubview:separator4];
    
    UILabel *parents = [[UILabel alloc]initWithFrame:CGRectMake(12, separator4.frame.origin.y+6, 70, 30)];
    parents.text = @"Parents";
    parents.textColor = [UIColor orangeColor];
    parents.font =  [UIFont systemFontOfSize:12];
    [contentVC.view addSubview:parents];


        [self presentViewController:contentVC animated:YES completion:nil];
    }

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection {
        return UIModalPresentationNone; // 20
    }
    
- (UIViewController *)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller.presentedViewController];
        return navController; // 21
    }


- (IBAction)notificationButtonPressed:(id)sender {
}

#pragma Mark - SWRevealViewController delegate methods
- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    self.homePageTableView.userInteractionEnabled =
    (revealController.frontViewPosition == FrontViewPositionRight ? FALSE : TRUE);
}

-(void)showPopUpBoxAtStartUp{
   locationPopup = [[MTGenericAlertView alloc] initWithTitle:@"Pick Up Your City" titleColor:[UIColor whiteColor] titleFont:nil backgroundImage:nil];
    
    //Add close button only to handle close button action. Other wise by default close button will be added.
    locationPopup.popUpCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [locationPopup.popUpCloseButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [locationPopup setCustomInputView:self.addressView];
    locationPopup.isPopUpView = YES;
    [locationPopup setDelegate:self];
    [locationPopup show];
    
}
@end
