//
//  QuickbitesViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "CurriesViewController.h"
#import "MealsTableViewCell.h"
#import "SVService.h"
#import "Product.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CurriesViewController (){
    MealsTableViewCell *cell;
    BOOL isCellExpanded;
}

@property(nonatomic, strong) NSMutableArray *dishImagesArray;
@property (weak, nonatomic) IBOutlet UITableView *curriesTableView;
@property (strong, nonatomic) NSMutableArray *productObjectsArray;



@end

@implementation CurriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _productObjectsArray = [[NSMutableArray alloc] init];
    self.dishImagesArray = [[NSMutableArray alloc]initWithObjects:@"dish1",@"dish2",@"dish3",@"dish4",@"dish5",@"dish6",@"dish7",@"dish8",@"dish9",@"dish10",@"dish11",@"dish12",@"dish13",@"dish14",@"dish15",@"dish16", nil];
    [self fetchAndLoadData];
    
    
    // [self.quickBitesTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isCellExpanded = NO;
}

-(void)fetchAndLoadData{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: kToken,@"token",  nil];
    SVService *service = [[SVService alloc] init];
    [service getQuickBitesProductsDataUsingBlock:dict usingBlock:^(NSMutableArray *resultArray) {
        
        if (resultArray.count == 0 || resultArray == nil) {
            //[self displayMessageWhenNoData];
        }
        
        _productObjectsArray = [resultArray copy];
        [self.curriesTableView reloadData];
        
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _productObjectsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MealsCellIdentifier";
    cell = (MealsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Making selection style none
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //[cell.contentView setLayoutMargins:UIEdgeInsetsMake(15, 0, 0, 0)];
    
    Product *product = _productObjectsArray[indexPath.row];
    
    //  NSString *imageName = [NSString stringWithFormat:@"Dish_Images/%@.jpg",self.dishImagesArray[indexPath.row]];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:product.image_url]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.titleLabel.text =product.name;
    cell.descriptionView.text = product.description;
    //[NSString stringWithFormat:@"Veg Manchurian  %ld",(long)indexPath.row];
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
