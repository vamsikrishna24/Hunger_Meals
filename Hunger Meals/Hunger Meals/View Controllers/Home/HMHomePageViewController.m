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
#import "HMMonthlyDetailViewController.h"
#import "HMMealPlannerViewController.h"
#import "SVService.h"
#import "LocationView.h"
#import "HMLandingViewController.h"

@interface HMHomePageViewController (){
    NSArray *categories;
    NSArray *categoriesImgs;
    NSArray *scrollingImgs;
    NSMutableArray *addressArray;
    UIButton *floatingButton;
    CLLocationManager *locationManager;
    MTGenericAlertView *locationPopup;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    UITableView *locationTable;
    UITextView *textView;
    CLLocation *currentLocation;
    NSMutableArray *locations;
    int selectedLocation;
    BOOL isLocationSelected;
    LocationView *locationView;
    MTGenericAlertView *MTGenericAlertViewtainer;
    
}

@property(nonatomic, strong) NSString *latitudeString;
@property(nonatomic, strong) NSString *longitudeStrinng;
@property(nonatomic, strong) NSString *addressStrinng;
@property(nonatomic,strong) NSString *locationAddressString;
@property(nonatomic,strong) HMLandingViewController *landingViewController;


@end

@implementation HMHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.homePageTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    categories = [NSArray arrayWithObjects: @"Meals",@"Monthly Meal Planner",@"Store", nil];
    
    categoriesImgs = [NSArray arrayWithObjects: @"Category1.png",@"Category2.png",@"Category3.png", nil];
    
    scrollingImgs = [NSArray arrayWithObjects: @"page1.png",@"page2.png",@"page3.png",@"page4.png", @"page5.png", nil];
    locationView = [[LocationView alloc]init];
    APPDELEGATE.homeNavigationController = self.navigationController;
    
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
    //[self showLocationPopUp];
    //    ([(AppDelegate *)[[UIApplication sharedApplication] delegate] enableCurrentLocation]);
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
        //[CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways
        ) {
        // Will open an confirm dialog to get user's approval
        [locationManager requestWhenInUseAuthorization];
    } else {
        [locationManager startUpdatingLocation]; //Will update location immediately
    }
    [locationManager startUpdatingLocation];
    NSLog(@"%@", [USER_DEFAULTS valueForKey: @"isLocationSelected"]);
    if ([[USER_DEFAULTS valueForKey: @"isLocationSelected"]  isEqual: @"NO"]) {
        [USER_DEFAULTS setObject: @"YES" forKey: @"isLocationSelected"];
        //[USER_DEFAULTS setValue: @"YES" forKey: @"isLocationSelected"];
        self.instanceView.frame = self.view.bounds;//CGRectMake(16, self.view.frame.size.height / 2 - 30, self.view.frame.size.width - 32, 60);
        self.instanceView.delegate = self;
        [self.instanceView setBackgroundColor: [UIColor clearColor]];
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        
        //         MTGenericAlertViewtainer = [[MTGenericAlertView alloc] initWithTitle:nil titleColor:nil titleFont:nil backgroundImage:nil];
        //        [MTGenericAlertViewtainer setCustomInputView:self.instanceView]; //Add customized view to this method
        //        MTGenericAlertViewtainer.tag = 3;
        //        // [MTGenericAlertViewtainer setCustomButtonTitlesArray:[NSMutableArray arrayWithObjects:@"OK",nil]];
        //        [MTGenericAlertViewtainer show];
        
        [self.view addSubview: self.instanceView];
        
        locations = [[NSMutableArray alloc] init];
    } else {
        self.instanceView.frame = self.view.bounds;
        self.instanceView.delegate = self;
        [self.instanceView setBackgroundColor: [UIColor clearColor]];
        //       // [MTGenericAlertViewtainer close];
        //
        //        MTGenericAlertViewtainer = [[MTGenericAlertView alloc] initWithTitle:nil titleColor:nil titleFont:nil backgroundImage:nil];
        //        [MTGenericAlertViewtainer setCustomInputView:self.instanceView]; //Add customized view to this method
        //        MTGenericAlertViewtainer.tag = 3;
        //        // [MTGenericAlertViewtainer setCustomButtonTitlesArray:[NSMutableArray arrayWithObjects:@"OK",nil]];
        //        [MTGenericAlertViewtainer show];
        
        
        
        [self.view addSubview: self.instanceView];
    }
    
    //[locations addObject: @{@"address": @"Banglore"}];
    //[self fetchLocation];
    
}

- (void)selectedLocation:(NSDictionary *)location {
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    self.instanceView.hidden = true;
    //[MTGenericAlertViewtainer close];
    isLocationSelected = NO;
    NSLog(@"Locattion: %@", location);
}
//-(void)showPopUpBoxAtStartUp{
//    locationPopup = [[MTGenericAlertView alloc] initWithTitle:@"Pick Up Your City" titleColor:[UIColor whiteColor] titleFont:nil backgroundImage:nil];
//
//    //Add close button only to handle close button action. Other wise by default close button will be added.
//    locationPopup.popUpCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    [locationPopup.popUpCloseButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
//    [locationPopup setCustomInputView:_popUpBoxView];
//    locationPopup.isPopUpView = YES;
//    [locationPopup setDelegate:self];
//    [locationPopup show];
//
//}

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
    
    self.landingViewController = [[HMLandingViewController alloc]init];

    
    
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
-(void)navigateToMealPlan{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    SVService *service = [[SVService alloc] init];
    [service getcurrmealplanusingBlock:^(NSDictionary *resultDict) {
        if (resultDict.count > 0) {
            NSMutableArray *lunchList = [resultDict valueForKeyPath:@"data.lunchplandata.title"];
            NSMutableArray *dinnerList = [resultDict valueForKeyPath:@"data.dinnerplandata.title"];
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            if (lunchList.count || dinnerList.count) {
                HMMealPlannerViewController *monthlyMealViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MonthlyMealsViewIdentifier"];
                [self.navigationController pushViewController:monthlyMealViewController animated:YES];
            }
            else {
                HMMonthlyDetailViewController *monthlyMealViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MonthlyRecommondationViewIdentifier"];
                [self.navigationController pushViewController:monthlyMealViewController animated:YES];
            }
            
        }
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}


#pragma Mark - TableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.locationTableView) {
        return locations.count;
    }
    if(tableView == locationTable && section == 0 ){
        return 1;
    }
    else if(tableView == locationTable && section == 1){
        return addressArray.count;
    }
    else return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.locationTableView) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *scrollingCellIdentifier = @"ScrollingCellIdentifier";
    static NSString *categoryCellIdentifier = @"HomeCategoryIdentifier";
    static NSString *LocationIdentifier = @"ScrollingCellIdentifier";
    static NSString *LocationIdenti = @"ScrollingCellIdentifier";
    static NSString *locIdentifier = @"LocationCell";
    
    UITableViewCell *cell;
    if (tableView == self.locationTableView) {
        LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: locIdentifier];
        cell.locationLabel.text = [locations [indexPath.row] valueForKey: @"name"];
        return cell;
    }

    if(tableView == locationTable && indexPath.section ==0){
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:LocationIdenti];
            
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10,10, cell.frame.size.width-20, 35)];
            textField.placeholder = @" enter your location";
            textField.backgroundColor = [UIColor clearColor];
            locationTable.backgroundColor = [UIColor clearColor];
            textField.layer.borderWidth = 1;
            textField.layer.borderColor = APPLICATION_COLOR.CGColor;
            textField.textColor = APPLICATION_COLOR;
            textField.alpha = 0.8;
            textField.clipsToBounds = YES;
            [cell.contentView addSubview:textField];
            cell.backgroundColor = [UIColor clearColor];
            
            UIButton *locateMeButton = [[UIButton alloc]initWithFrame:CGRectMake(10, textField.frame.size.height+textField.frame.origin.y, cell.frame.size.width-20, 35)];
            [locateMeButton setTitle:@"Let us locate you?" forState:UIControlStateNormal];
            [locateMeButton addTarget: self action: @selector(showCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
            [locateMeButton setTitleColor:APPLICATION_COLOR forState:UIControlStateNormal];
            locateMeButton.titleLabel.font = [UIFont systemFontOfSize:16];
            [cell.contentView addSubview:locateMeButton];
            
            cell.selectionStyle = NO;
            
        }
    }else if(tableView == locationTable && indexPath.section ==1){
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:LocationIdentifier];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        NSString * stringToDisplay = (NSString *)[[addressArray valueForKey:@"address"] componentsJoinedByString:@""];
        textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, 320, 40)];
        textView.textAlignment = NSTextAlignmentLeft;
        textView.backgroundColor = [UIColor clearColor];
        //        textView.alpha = 0.5;
        //        cell.contentView.backgroundColor = [UIColor clearColor];
        locationTable.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textView];
        textView.text = stringToDisplay;
        textView.editable = NO;
        textView.selectable = NO;
        textView.textColor = APPLICATION_COLOR;
        
    }else{
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
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([[USER_DEFAULTS valueForKey: @"isGuestLogin"]  isEqual: @"YES"]){
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Sign in required" message:@"Sign in with your account to explore all features in the app" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        
        [alert show];
        
       
        
    }else if ([[USER_DEFAULTS valueForKey: @"isGuestLogin"]  isEqual: @"NO"]) {
    if (tableView == self.locationTableView) {
        selectedLocation = (int)indexPath.row;
        self.instanceView.hidden = true;
    } else {
        if (indexPath.row == 1) {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HMCartViewController *cartViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MealsViewIdentifier"];
            [self.navigationController pushViewController:cartViewController animated:YES];
            
        }
        
        if (indexPath.row == 2) {
            [self navigateToMealPlan];
        }
        
        if (indexPath.row == 3) {
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HMCartViewController *cartViewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MealsViewIdentifier"];
            [self.navigationController pushViewController:cartViewController animated:YES];
            
        }
        
        }
    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        //cancel clicked ...do your action
    }else{
        [USER_DEFAULTS setObject: @"NO" forKey: @"isGuestLogin"];
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        
        HMLandingViewController *loginVC = (HMLandingViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"LandingPage"];
        
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(tableView == locationTable &&indexPath.section == 0){
        return 80;
    }else if(tableView == locationTable &&indexPath.section == 1){
        return 40;
    }
    if(tableView == self.homePageTableView ){
        if (indexPath.row == 0) {
            return 166;
        }
        CGRect deviceFrame = DEVICEFRAME;
        CGFloat height = deviceFrame.size.height;
        
        return (height-270)/3;
    }
    return 0;
}

- (IBAction)menuButtonTapped:(id)sender {
    
}

- (IBAction)locationButtonTapped:(id)sender {
    isLocationSelected = !isLocationSelected;
    if (isLocationSelected) {
        self.instanceView.hidden = NO;
    } else {
        self.instanceView.hidden = YES;
        
    }
    //    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    HMContentViewController *contentVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    //        contentVC.view.backgroundColor = [UIColor clearColor];
    //        contentVC.modalPresentationStyle = UIModalPresentationPopover;
    //        UIPopoverPresentationController *popPC = contentVC.popoverPresentationController;
    //        popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
    //        popPC.delegate = self;
    //        popPC.barButtonItem = sender;
    //    CGSize finalDesiredSize = CGSizeMake(320, 190);
    //
    //    CGSize tempSize = CGSizeMake(finalDesiredSize.width, finalDesiredSize.height + 1);
    //    [contentVC setPreferredContentSize:tempSize];
    //    [contentVC setPreferredContentSize:finalDesiredSize];
    //
    //
    //    locationTable = [[UITableView alloc]initWithFrame:CGRectMake(contentVC.view.frame.origin.x,contentVC.view.frame.origin.y,320,190)];
    //    locationTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    //
    //    locationTable.dataSource = self;
    //    locationTable.delegate = self;
    //    locationTable.backgroundColor = [UIColor clearColor];
    //    locationTable.separatorColor = [UIColor lightGrayColor];
    //    [contentVC.view addSubview:locationTable];
    //
    //
    //    locationManager.delegate = self;
    //    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
    //        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
    //        //[CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways
    //        ) {
    //        // Will open an confirm dialog to get user's approval
    //        [locationManager requestWhenInUseAuthorization];
    //    } else {
    //        [locationManager startUpdatingLocation]; //Will update location immediately
    //    }
    //    [locationManager startUpdatingLocation];
    //    [self presentViewController:contentVC animated:YES completion:nil];
    //    [self fetchLocation ];
    //self.instanceView.hidden = NO;
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
- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position {
    self.homePageTableView.userInteractionEnabled =
    (revealController.frontViewPosition == FrontViewPositionRight ? FALSE : TRUE);
}

-(void)showLocationPopUp {
    
    locationPopup = [[MTGenericAlertView alloc] initWithTitle:@"Select your Location" titleColor:APPLICATION_TITLE_COLOR titleFont:[Fonts nevisWithSize:16.0] backgroundImage:nil];
    
    //Add close button only to handle close button action. Other wise by default close button will be added.
    locationPopup.popUpCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [locationPopup.popUpCloseButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [locationPopup setCustomInputView:self.addressView];
    locationPopup.isPopUpView = YES;
    [locationPopup setDelegate:self];
    [locationPopup show];
    
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

//************************************************
#pragma mark - CLLocation Manager delegate methods
//************************************************

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *currentLoc = locations.lastObject;
    currentLocation = currentLoc;
    //NSLog(@"Current Location: %@", currentLoc);
}

/*
 - (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
 {
 NSLog(@"didUpdateToLocation: %@", newLocation);
 CLLocation *currentLocation = newLocation;
 
 if (currentLocation != nil) {
 self.longitudeStrinng = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
 self.latitudeString = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
 }
 
 // Reverse Geocoding
 NSLog(@"Resolving the Address");
 [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
 NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
 if (error == nil && [placemarks count] > 0) {
 placemark = [placemarks lastObject];
 self.addressStrinng = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
 placemark.subThoroughfare, placemark.thoroughfare,
 placemark.postalCode, placemark.locality,
 placemark.administrativeArea,
 placemark.country];
 } else {
 NSLog(@"%@", error.debugDescription);
 }
 } ];
 
 }
 */

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
        } break;
        case kCLAuthorizationStatusDenied: {
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [locationManager startUpdatingLocation]; //Will update location immediately
        } break;
        default:
            break;
    }
}

- (void)showCurrentLocation {
    NSLog(@"Resolving the Address");
    geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            self.addressStrinng = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                   placemark.subThoroughfare, placemark.thoroughfare,
                                   placemark.postalCode, placemark.locality,
                                   placemark.administrativeArea,
                                   placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}

- (void)locationResponse:(NSString *)message {
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Oops" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    self.instanceView.hidden = YES;
}

-(void)fetchLocation{
    //[self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    SVService *service = [[SVService alloc] init];
    //    [service getLocationsDataUsingBlock:^(NSMutableArray *resultArray) {
    //        addressArray = resultArray;
    //        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    //        [self.locationTableView reloadData];
    //        [locationTable reloadData];
    //
    //    }];
    [service getLocationsDataUsingBlock:^(NSMutableArray *resultArray) {
        //[self createSelectInstancePopUp];
        //        locations = resultArray;
        //        self.locationTableView.delegate = self;
        //        self.locationTableView.dataSource = self;
        //        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
        //        [self.locationTableView reloadData];
        //        [self.view bringSubviewToFront: self.locationView];
        
    }];
    
}

#pragma mark - Select Instance PopUp
//- (void)createSelectInstancePopUp {
//    
//    _selectInstancePopUp = [[PCSAlertViewContainer alloc]init];
//    _instanceView.frame = CGRectMake(0, 0, 240, 300);
//    [_selectInstancePopUp setContainerViewContent: _instanceView];
//    [_selectInstancePopUp show];
//}


#pragma TableViewDelate Methods



@end
