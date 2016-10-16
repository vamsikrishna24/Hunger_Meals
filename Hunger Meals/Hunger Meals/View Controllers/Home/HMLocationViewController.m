//
//  HMLocationViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 09/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMLocationViewController.h"
#import "BTAlertController.h"
#import <CoreData/CoreData.h>

@interface HMLocationViewController ()


@end

@implementation HMLocationViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //To Get user current location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
    
    [locationManager startUpdatingLocation];
    
    self.navigationItem.title = @"Locations";
}

-(void)viewWillAppear:(BOOL)animated{
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Device"];
    self.addresses = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.notificationsTableView reloadData];

}

#pragma mark - Custom Methods
- (IBAction)backCustom:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlertWithMsg:(NSString *)msg{
    [BTAlertController showAlertWithMessage:msg andTitle:@"" andOkButtonTitle:nil andCancelTitle:@"Ok" andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _addresses.count;
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
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    
    // 2. Set a custom background color and a border
    footerView.backgroundColor = APPLICATION_COLOR;
    footerView.layer.borderColor = [UIColor colorWithWhite:0.5 alpha:1.0].CGColor;
    footerView.layer.borderWidth = 1.0;
    
    // 3. Add a label
    UIButton* footerButton = [[UIButton alloc] init];
    footerButton.frame = CGRectMake(5, 2, tableView.frame.size.width - 5, 40);
    footerButton.backgroundColor = [UIColor clearColor];
    [footerButton setTitle:@"Add New Address" forState:UIControlStateNormal];
    [footerView addSubview:footerButton];
    
    return footerView;
}

//************************************************
#pragma mark - CLLocation Manager delegate methods
//************************************************

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [self showAlertWithMsg:@"Failed to Get Your Location"];
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

#pragma mark - Core Data Methods
- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)saveAddressToDB:(id)sender {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object for Address
    NSManagedObject *addressEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Addresses" inManagedObjectContext:context];
    [addressEntity setValue:self.addressTextView.text forKey:@"address"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        [self showAlertWithMsg:@"While saving your address error encountered. Please try again"];
        
    }
    else{
        [self showAlertWithMsg:@"Your address has been saved successfully"];
    }
    
    
}

@end
