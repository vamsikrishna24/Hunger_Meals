//
//  HMSignUpThirdViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 20/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMSignUpThirdViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HMSignUpThirdViewController (){
    NSInteger index;
    int *count;
}

@end

@implementation HMSignUpThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    index = 0;
    [self.addressTableView setBackgroundColor:[UIColor clearColor]];
    self.addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"AddressTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.contentView.layer.cornerRadius = 5.0f;

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor clearColor];
    headerView.layer.borderColor = [UIColor clearColor].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, tableView.frame.size.width, 17)];
    
    // 2. Set a custom background color and a border
    headerLabel.layer.borderColor = [UIColor clearColor].CGColor;
    headerLabel.layer.borderWidth = 1.0;
    headerLabel.textColor =[UIColor colorWithRed:0.901 green:0.521 blue:0.215 alpha:1.0f];
    headerLabel.font=[headerLabel.font fontWithSize:12];
    headerLabel.text =@"Home";
    [headerView addSubview:headerLabel];
   // 24914818
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40; // you can have your own choice, of course
}

- (IBAction)addAddressAction:(id)sender {
    //other code related to table
    self.addressTableView.tag = ++index;
    [self newSection];
}
- (IBAction)skipButtonAction:(id)sender {
}
- (IBAction)saveButtonAction:(id)sender {
}
-(void)newSection
{
    count++;
    [self.addressTableView reloadData];
}
@end
