//
//  NorthIndianViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "NorthIndianViewController.h"
#import "MealsTableViewCell.h"
#import "SVService.h"
#import "Product.h"

@interface NorthIndianViewController (){
    BOOL isCellExpanded;
    NSInteger tableViewHeight;
    NSMutableArray *productObjectsArray;

}

@property(nonatomic, strong) NSMutableArray *dishImagesArray;

@property (weak, nonatomic) IBOutlet UITableView *northIndianTableView;


@end

@implementation NorthIndianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dishImagesArray = [[NSMutableArray alloc]initWithObjects:@"dish1",@"dish2",@"dish3",@"dish4",@"dish5",@"dish6",@"dish7",@"dish8",@"dish9",@"dish10",@"dish11",@"dish12",@"dish13",@"dish14",@"dish15",@"dish16", nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchAndLoadData]; 
    isCellExpanded = NO;
    tableViewHeight = 210;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [productObjectsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MealsCellIdentifier";
    MealsTableViewCell *cell = (MealsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    Product *product = productObjectsArray[indexPath.row];
//
//    NSString *imageName = [NSString stringWithFormat:@"Dish_Images/%@.jpg",self.dishImagesArray[indexPath.row]];
//    cell.itemImageView.image = [UIImage imageNamed:imageName];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:product.image_url]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    cell.titleLabel.text = product.name;
    cell.descriptionView.text = product.description;
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

-(void)fetchAndLoadData{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: kToken,@"token",  nil];
    SVService *service = [[SVService alloc] init];
    [service getNorthIndianProductsDataUsingBlock:dict usingBlock:^(NSMutableArray *resultArray) {
        
        if (resultArray.count == 0 || resultArray == nil) {
            //[self displayMessageWhenNoData];
        }
        productObjectsArray = [resultArray copy];
        [self.northIndianTableView reloadData];
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}
@end
