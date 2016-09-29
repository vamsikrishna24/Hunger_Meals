//
//  SlideMenuViewController.m
//  Hunger Meals
//
//  Created by SivajeeBattina on 7/14/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "SlideMenuViewController.h"

@interface SlideMenuViewController (){

    NSMutableArray *slideMenuCategories;
}

@end

@implementation SlideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    slideMenuCategories = [[NSMutableArray alloc] initWithObjects: @"Meals", @"Monthly Plan",@"Shop",@"Orders",@"Invite",@"Help",@"Sign Out", nil];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
    self.profileImageView.clipsToBounds = true;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return slideMenuCategories.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"SlideMenuCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *categoryLabel = (UILabel *)[cell viewWithTag:1];
    categoryLabel.text = slideMenuCategories[indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue { }

@end
