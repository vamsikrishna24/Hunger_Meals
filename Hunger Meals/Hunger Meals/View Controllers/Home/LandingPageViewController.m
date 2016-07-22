//
//  ViewController.m
//  Hunger Meals
//
//  Created by Vamsi T on 08/07/2016.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "LandingPageViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Utility.h"

#define CELLSPACING 10
#define STATUSNAVIGATIONHEIGHT 60
@interface LandingPageViewController ()<CLLocationManagerDelegate>

@property(nonatomic) BOOL isSearching;
@property(nonatomic, strong) NSString *searchStr;
@property(nonatomic, strong) NSMutableArray *searchFeedArray;
@property(nonatomic, strong) NSMutableArray *collectionFeedArray;

@end

static NSString * const cellIdentifier = @"MealItemCellIdentifier";
@implementation LandingPageViewController
{
    CLLocationManager *locationManager;
    MTGenericAlertView *locationPopup;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Menu open/close based on gesture recognizer
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    [self.slidingViewController.topViewController.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    //Showing popup at intial
    [self showPopUpBoxAtStartUp];
    
    //To Get user current location
    locationManager = [[CLLocationManager alloc] init];
    
    //Search initializers
    self.searchStr = @"";
    self.isSearching = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self addSearchBar];
}
//**********************************
#pragma mark - Action Methods
//**********************************

- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

-(IBAction)locateMeButtonClicked:(id)sender{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

//**********************************
#pragma mark - Custom methods
//**********************************
-(void)showPopUpBoxAtStartUp{
    locationPopup = [[MTGenericAlertView alloc] initWithTitle:@"Pick Up Your City" titleColor:[UIColor whiteColor] titleFont:nil backgroundImage:nil];
    
    //Add close button only to handle close button action. Other wise by default close button will be added.
    locationPopup.popUpCloseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [locationPopup.popUpCloseButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [locationPopup setCustomInputView:_popUpBoxView];
    locationPopup.isPopUpView = YES;
    [locationPopup setDelegate:self];
    [locationPopup show];

}

//**********************************
#pragma mark - Alert methods
//**********************************

- (void)alertView:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

}

//************************************************
#pragma mark - CLLocation Manager delegate methods
//************************************************

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to Get Your Location" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [errorAlert addAction:okAction];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSLog(@"User Location: %@", currentLocation);
    }
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
    [locationPopup close];
}

//************************************************
#pragma mark - Search methods
//************************************************

- (void)addSearchBar
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.definesPresentationContext = YES;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.showsCancelButton = YES;
    self.searchController.active = YES;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.isSearching  = YES;
    
    NSString *searchString = [Utility getStringWithTrimSpaces:searchBar.text];
    
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    self.isSearching = NO;
    [searchBar resignFirstResponder];
    searchBar.text = @"";
    [self.collectionView reloadData];
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //    self.isSearching = YES;
    //    [self.collectionView reloadData];
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.searchStr = searchBar.text;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    //    [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
    //    [self.collectionView reloadData];
}

//************************************************
#pragma mark - UICollectionView Datasource
//************************************************

- (NSInteger) numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    return 12;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = (UICollectionViewCell *)[cv dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
 
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect collectionViewSize = collectionView.bounds;
    
    CGFloat cellWidth = (collectionViewSize.size.width-(3*CELLSPACING))/2;
//    CGFloat cellHeight = (collectionViewSize.size.height-(3*CELLSPACING)-STATUSNAVIGATIONHEIGHT)/3;
    CGFloat cellHeight = 220;
    CGSize cellSize = CGSizeMake(cellWidth, cellHeight);
    
    return cellSize;
    
}

- (UIEdgeInsets) collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
