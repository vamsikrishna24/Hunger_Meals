//
//  AddonsViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "AddonsViewController.h"
#import "MealsTableViewCell.h"

@interface AddonsViewController (){
    BOOL isCellExpanded;
    NSInteger tableViewHeight;
}

@property(nonatomic, strong) NSMutableArray *dishImagesArray;



@end

@implementation AddonsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dishImagesArray = [[NSMutableArray alloc]initWithObjects:@"dish1",@"dish2",@"dish3",@"dish4",@"dish5",@"dish6",@"dish7",@"dish8",@"dish9",@"dish10",@"dish11",@"dish12",@"dish13",@"dish14",@"dish15",@"dish16", nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isCellExpanded = NO;
    tableViewHeight = 210;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.dishImagesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MealsCellIdentifier";
    MealsTableViewCell *cell = (MealsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSString *imageName = [NSString stringWithFormat:@"Dish_Images/%@.jpg",self.dishImagesArray[indexPath.row]];
    cell.itemImageView.image = [UIImage imageNamed:imageName];
    cell.titleLabel.text = [NSString stringWithFormat:@"Hot and Spicy Food Item  %ld",(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView beginUpdates];
    [tableView endUpdates];
    isCellExpanded = !isCellExpanded;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *selectedIndexPath  = [tableView indexPathForSelectedRow];
    
    if ([indexPath isEqual:selectedIndexPath] && !isCellExpanded) {
        return 440;
    }
    return 345;
}

@end
