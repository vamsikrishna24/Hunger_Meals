//
//  MealsViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "MealsViewController.h"
#import "YSLContainerViewController.h"
#import "QuickbitesViewController.h"
#import "SouthIndianViewController.h"
#import "NorthIndianViewController.h"
#import "AddonsViewController.h"
#import "CurriesViewController.h"
#import "Fonts.h"

@interface MealsViewController ()<YSLContainerViewControllerDelegate>

@end

@implementation MealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QuickbitesViewController *quickBitesVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"QuickBitesViewIdentifier"];
    quickBitesVC.title = @"QUICK BITES";
    SouthIndianViewController *southIndianVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SouthIndianViewIdentifier"];
    southIndianVC.title = @"SOUTH INDIAN";
    NorthIndianViewController *northIndianVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"NorthIndianViewIdentifier"];
    northIndianVC.title = @"NORTH INDIAN";
    CurriesViewController *curriesVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CurriesViewIdentifier"];
    curriesVC.title = @"BIRYANI";
    AddonsViewController *addOnsVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddonsViewIdentifier"];
    addOnsVC.title = @"ADD-ONS";
    
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGRect frame = CGRectMake(0, 0, DEVICEFRAME.size.width, DEVICEFRAME.size.height+20);
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc] initWithControllers:@[quickBitesVC,southIndianVC,northIndianVC,curriesVC,addOnsVC] topBarHeight:statusHeight + navigationHeight withFrame:frame parentViewController:self];
    
    containerVC.menuItemFont = [Fonts helveticaBoldWithSize:11.0];
    containerVC.menuItemTitleColor = APPLICATION_SUBTITLE_COLOR;
    containerVC.menuItemSelectedTitleColor = APPLICATION_COLOR;
    containerVC.menuIndicatorColor = APPLICATION_COLOR;
    containerVC.menuBackGroudColor = [UIColor colorWithRed:238.0/255.0f green:238.0/255.0f blue:238.0/255.0f alpha:1.0f];

    [self.view addSubview:containerVC.view];
    
}

#pragma mark -- YSLContainerViewControllerDelegate
- (void)containerViewItemIndex:(NSInteger)index currentController:(UIViewController *)controller
{
    //    NSLog(@"current Index : %ld",(long)index);
    //    NSLog(@"current controller : %@",controller);
    [controller viewWillAppear:YES];
}

@end
