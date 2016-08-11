//
//  HMHomePageViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 06/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMHomePageViewController.h"
#import "HMLocationViewController.h"
#import "SWRevealViewController.h"
#import "SlideMenuViewController.h"

@interface HMHomePageViewController (){
    NSArray *objects;
    
}

@end

@implementation HMHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homePageTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.navigationItem.title = @"Hungry Meals";
    
    
    //Menu open/close based on gesture recognizer
    SWRevealViewController *revealController = self.revealViewController;
    if (revealController)
    {
        [self.slideBarButton setTarget: self.revealViewController];
        [self.slideBarButton setAction: @selector( revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma Mark - TableView Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"HomeIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    objects = [NSArray arrayWithObjects:@"Quick Bites", @"Meals",@"Monthly Meal",@"Shop", nil];
    cell.textLabel.text = [objects objectAtIndex:indexPath.row];
         return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (IBAction)menuButtonTapped:(id)sender {

}

- (IBAction)locationButtonTapped:(id)sender {
    
//    HMNotificationsViewController *notificationVC = [[HMNotificationsViewController alloc] init];
//    [self presentViewController:notificationVC animated:YES completion:nil];
    
}

- (IBAction)notificationButtonPressed:(id)sender {
}
@end
