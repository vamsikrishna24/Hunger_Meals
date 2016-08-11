//
//  HMLocationViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 09/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMLocationViewController.h"

@interface HMLocationViewController (){
    CLLocationManager *locationManager;
}


@end

@implementation HMLocationViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //To Get user current location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    self.navigationItem.title = @"Locations";
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    //self.notificationsTableView.tableFooterView =self.footerView;

}

- (IBAction)backCustom:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"NotificationIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // 1. The view for the header
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    
    // 2. Set a custom background color and a border
    footerView.backgroundColor = [UIColor orangeColor];
    footerView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    footerView.layer.borderWidth = 1.0;
    
    // 3. Add a label
    UIButton* footerButton = [[UIButton alloc] init];
    footerButton.frame = CGRectMake(5, 2, tableView.frame.size.width - 5, 22);
    footerButton.backgroundColor = [UIColor clearColor];
    [footerButton setTitle:@"Add New Address" forState:UIControlStateNormal];
    [footerView addSubview:footerButton];
    
    return footerView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//************************************************
#pragma mark - CLLocation Manager delegate methods
//************************************************

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Failed to Get Your Location" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [errorAlert addAction:okAction];
    
    [self presentViewController:errorAlert animated:YES completion:nil];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSLog(@"User Location: %@", currentLocation);
    }
    self.locatinLabel.text =  [NSString stringWithFormat:@"%@",currentLocation];
    
    // Stop Location Manager
    [locationManager stopUpdatingLocation];
}


@end
