//
//  HMSignUpPageViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 19/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMSignUpPageViewController.h"
#import "HMOTPVerificationViewController.h"
#import "HMSignUpFirstViewController.h"
#import "HMSignUpThirdViewController.h"

@interface HMSignUpPageViewController (){
    HMSignUpFirstViewController *firstVC;
    HMOTPVerificationViewController *SecondVC;
    HMSignUpThirdViewController *thirdVC;
}

@end

@implementation HMSignUpPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    // Do any additional setup after loading the view.

        firstVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstPage"];
        SecondVC = [self.storyboard instantiateViewControllerWithIdentifier:@"secondPage"];
        thirdVC= [self.storyboard instantiateViewControllerWithIdentifier:@"thirdPage"];

    NSArray *viewControllers = @[firstVC];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+40);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{

    if(index == 0){
        
        return firstVC;
    }else if(index == 1){
        
        return SecondVC;
        
    }else if(index == 2){
        
        return thirdVC;
    }return nil;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController

{
    NSInteger index;
    if([viewController isKindOfClass: NSClassFromString([NSString stringWithFormat:@"HMSignUpFirstViewController"])]){
        
         index = ((HMSignUpFirstViewController *)viewController).pageIndex;
        
    }else if([viewController isKindOfClass: NSClassFromString([NSString stringWithFormat:@"HMOTPVerificationViewController"])]){
         index = ((HMOTPVerificationViewController *)viewController).pageIndex;

    }else if([viewController isKindOfClass: NSClassFromString([NSString stringWithFormat:@"HMSignUpThirdViewController"])]){
         index = ((HMSignUpThirdViewController *)viewController).pageIndex;

    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index;
    if([viewController isKindOfClass: NSClassFromString([NSString stringWithFormat:@"HMSignUpFirstViewController"])]){
        
        index = ((HMSignUpFirstViewController *)viewController).pageIndex;
        
    }else if([viewController isKindOfClass: NSClassFromString([NSString stringWithFormat:@"HMOTPVerificationViewController"])]){
        index = ((HMOTPVerificationViewController *)viewController).pageIndex;
        
    }else if([viewController isKindOfClass: NSClassFromString([NSString stringWithFormat:@"HMSignUpThirdViewController"])]){
        index = ((HMSignUpThirdViewController *)viewController).pageIndex;
        
    }
    index ++;
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return 3;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
