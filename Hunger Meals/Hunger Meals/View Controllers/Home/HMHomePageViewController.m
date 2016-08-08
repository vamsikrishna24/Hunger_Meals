//
//  HMHomePageViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 06/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMHomePageViewController.h"

@interface HMHomePageViewController (){
    NSArray *objects;
}

@end

@implementation HMHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homePageTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
