//
//  QuickbitesViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "QuickbitesViewController.h"
#import "MealsTableViewCell.h"
#import "SVService.h"

@interface QuickbitesViewController (){
    NSMutableArray *productObjectsArray;
    MealsTableViewCell *cell;
    BOOL isCellExpanded;
}

@property(nonatomic, strong) NSMutableArray *dishImagesArray;
@property (weak, nonatomic) IBOutlet UITableView *quickBitesTableView;


@end

@implementation QuickbitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    productObjectsArray = [[NSMutableArray alloc] init];
    self.dishImagesArray = [[NSMutableArray alloc]initWithObjects:@"dish1",@"dish2",@"dish3",@"dish4",@"dish5",@"dish6",@"dish7",@"dish8",@"dish9",@"dish10",@"dish11",@"dish12",@"dish13",@"dish14",@"dish15",@"dish16", nil];
    [self fetchAndLoadData];
    [self.quickBitesTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isCellExpanded = NO;
}

-(void)fetchAndLoadData{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    SVService *service = [[SVService alloc] init];
    [service getProductsDataUsingBlock:^(NSMutableArray *resultArray) {
        
        if (resultArray.count == 0 || resultArray == nil) {
            //[self displayMessageWhenNoData];
        }
        productObjectsArray = [resultArray copy];
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.dishImagesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MealsCellIdentifier";
    cell = (MealsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //Making selection style none
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView setLayoutMargins:UIEdgeInsetsMake(15, 10, 0, 10)];
    
    NSString *imageName = [NSString stringWithFormat:@"Dish_Images/%@.jpg",self.dishImagesArray[indexPath.row]];
    cell.itemImageView.image = [UIImage imageNamed:imageName];
    cell.titleLabel.text = [NSString stringWithFormat:@"Veg Manchurian  %ld",(long)indexPath.row];
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
        return 415;
    }
    return 330;
}
//- (IBAction)addToCartAction:(id)sender {
//    cell.addToCartButton.hidden = YES;
//    cell.stepperView.hidden = NO;
//}

- (IBAction)nonVegetarianAction:(id)sender {
    NSString *tem = self.nonVegetarianButtonOutlet.titleLabel.text;
    
    if (tem != nil && ![tem isEqualToString:@""]) {
        NSMutableAttributedString *temString=[[NSMutableAttributedString alloc]initWithString:tem];
        [temString addAttribute:NSUnderlineStyleAttributeName
                          value:[NSNumber numberWithInt:1]
                          range:(NSRange){0,[temString length]}];
        
        self.nonVegetarianButtonOutlet.titleLabel.attributedText = temString;
   }

}

- (IBAction)vegetarianAction:(id)sender {
    NSString *tem = self.vegetarianButtonOutlet.titleLabel.text;
    
    if (tem != nil && ![tem isEqualToString:@""]) {
        NSMutableAttributedString *temString=[[NSMutableAttributedString alloc]initWithString:tem];
        [temString addAttribute:NSUnderlineStyleAttributeName
                          value:[NSNumber numberWithInt:1]
                          range:(NSRange){0,[temString length]}];
        
        self.vegetarianButtonOutlet.titleLabel.attributedText = temString;
        self.nonVegetarianButtonOutlet.selected = NO;

    }
}
@end
