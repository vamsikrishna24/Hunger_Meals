//
//  ViewController.h
//  Hunger Meals
//
//  Created by Vamsi T on 08/07/2016.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTGenericAlertView.h"

@interface LandingPageViewController : UIViewController<MTGenericAlertViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, weak) IBOutlet UIView *popUpBoxView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


- (IBAction)menuButtonTapped:(id)sender;

@end

