//
//  MealsViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "MealsViewController.h"
#import "YSLContainerViewController.h"
#import "QuickbitesViewController.h";
#import "SouthIndianViewController.h";
#import "NorthIndianViewController.h";
#import "AddonsViewController.h";

@interface MealsViewController ()<YSLContainerViewControllerDelegate>

@end

@implementation MealsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    QuickbitesViewController *quickBitesVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"QuickBitesViewIdentifier"];
    quickBitesVC.title = @"Quick Bites";
    SouthIndianViewController *southIndianVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SouthIndianViewIdentifier"];
    southIndianVC.title = @"South Indian";
    NorthIndianViewController *northIndianVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"NorthIndianViewIdentifier"];
    northIndianVC.title = @"North Indian";
    AddonsViewController *addOnsVC = [mainStoryBoard instantiateViewControllerWithIdentifier:@"AddonsViewIdentifier"];
    addOnsVC.title = @"Add-ons";
    
    float statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationHeight = self.navigationController.navigationBar.frame.size.height;
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc]initWithControllers:@[quickBitesVC,southIndianVC,northIndianVC,addOnsVC]
                                                                                        topBarHeight:statusHeight + navigationHeight
                                                                                parentViewController:self];
    containerVC.menuItemFont = [UIFont fontWithName:@"Futura-Medium" size:10];
    containerVC.menuItemTitleColor = [UIColor colorWithRed:253/255.0f green:165/255.0f blue:57/255.0f alpha:1.0f];
    containerVC.menuItemSelectedTitleColor = [UIColor colorWithRed:253/255.0f green:165/255.0f blue:57/255.0f alpha:1.0f];
    containerVC.menuIndicatorColor = [UIColor colorWithRed:253/255.0f green:165/255.0f blue:57/255.0f alpha:1.0f];
    containerVC.menuBackGroudColor = [UIColor colorWithRed:65.0/255.0f green:65.0/255.0f blue:65.0/255.0f alpha:1.0f];
    
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
