//
//  HmDelieveriAddressViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 13/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HmDelieveriAddressViewController.h"
#import "HMPaymentTypeSelectionViewController.h"
#import "SVService.h"

@interface HmDelieveriAddressViewController (){
    CALayer *bottomBorder;
    NSMutableArray *savedLocationIDs;
    NSString *selectedAddressType;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *addressString;
    double latitudeValue;
    double longitudeValue;

}

@end

@implementation HmDelieveriAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    geocoder = [[CLGeocoder alloc] init];
    savedLocationIDs = [[NSMutableArray alloc] init];
    latitudeValue = 0;
    longitudeValue = 0;
    
    [self textFieldProperties];
    
    [self TextFieldsFonts];
    self.title = @"Delivery address";
    [self.homeButtonOutlet.layer setValue:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
    selectedAddressType = @"HOME";
   // self.saveButton.enabled = NO;
    
}
-(void)textFieldProperties{
    
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.pinCodeTextField.frame.size.height - 1, self.pinCodeTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.pinCodeTextField.layer addSublayer:bottomBorder];
    
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.deliveryAddressTextFiels.frame.size.height - 1, self.deliveryAddressTextFiels.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.deliveryAddressTextFiels.layer addSublayer:bottomBorder];
    
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.flatNumberTextField.frame.size.height - 1, self.flatNumberTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.flatNumberTextField.layer addSublayer:bottomBorder];

    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.areaLocalityTextField.frame.size.height - 1, self.areaLocalityTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.areaLocalityTextField.layer addSublayer:bottomBorder];
    
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.stateTextField.frame.size.height - 1, self.stateTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.stateTextField.layer addSublayer:bottomBorder];
    
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.cityTextField.frame.size.height - 1, self.cityTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.cityTextField.layer addSublayer:bottomBorder];

    
}

-(void)TextFieldsFonts{
    UIColor *color = [UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:0.5];
    self.pinCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Pincode" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.deliveryAddressTextFiels.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Delivery Time" attributes:@{NSForegroundColorAttributeName: color}];
    
       self.flatNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Building/Flat No/House No" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.areaLocalityTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Area/Locality" attributes:@{NSForegroundColorAttributeName: color}];
   
    
    self.stateTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"State" attributes:@{NSForegroundColorAttributeName: color}];
   
    
    self.cityTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"City" attributes:@{NSForegroundColorAttributeName: color}];
   
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

- (void) saveLocation{
    [self showActivityIndicatorWithTitle:@"Please wait..."];
    [self getLocationFromAddressString:self.cityTextField.text];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: selectedAddressType, @"addresstype", self.cityTextField.text, @"name", self.cityTextField.text, @"city", self.areaLocalityTextField.text, @"sublocation",  self.flatNumberTextField.text, @"address", latitudeValue,  @"lat", longitudeValue, @"lng", self.pinCodeTextField.text, @"zip", @"userlocation", @"type", nil];
    SVService *service = [[SVService alloc] init];
    [service getLocationID:dict usingBlock:^(NSString *locationId) {
        if (locationId != nil) {
            [self syncLocationForUser:locationId];
            [savedLocationIDs addObject:locationId];
        } else {
            [self hideActivityIndicator];
        }
    }];
}

-(void) getLocationFromAddressString: (NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    
    latitudeValue = latitude;
    longitudeValue = longitude;
    
    
}


- (void)syncLocationForUser:(NSString *)locationID{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: locationID, @"location_id", nil];
    SVService *service = [[SVService alloc] init];
    [service syncLocationToUserAccount:dict usingBlock:^(NSString *resultMessage) {
        
        if (resultMessage != nil || ![resultMessage isEqualToString:@""]) {
            NSLog(@"%@", resultMessage);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        [self hideActivityIndicator];
    }];
    
}


- (IBAction)saveAddress:(id)sender {
    if (![[self checkFieldsValidity]  isEqual: @""]) {
        [self showAlertWithTitle:@"Hunger Meals" andMessage:[self checkFieldsValidity]];
    }
    else {
        [self saveLocation];
    }
}

-(NSString *)checkFieldsValidity{
    if (self.pinCodeTextField.text.length != 6) {
        return @"Please enter valid pincode";
    }
    else if (self.flatNumberTextField.text.length == 0 || self.areaLocalityTextField.text.length == 0 || self.deliveryAddressTextFiels.text.length == 0 || self.stateTextField.text.length == 0 || self.cityTextField.text.length ==0) {
        return @"Fields should not be empty";
    }
    
    return @"";
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message{
    [BTAlertController showAlertWithMessage:message andTitle:title andOkButtonTitle:nil andCancelTitle:@"Ok" andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        
    }];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ToDeliverySelection"]){
        HMPaymentTypeSelectionViewController *paymentVC = (HMPaymentTypeSelectionViewController *)segue.destinationViewController;
        paymentVC.PaymentAmountString = self.PaymentAmountString;
        paymentVC.latitude = latitudeValue;
        paymentVC.longitude = longitudeValue;
    }
}

#pragma Mark - TextField Delegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if(self.pinCodeTextField.text.length > 0 && self.deliveryAddressTextFiels.text.length > 0 && self.flatNumberTextField.text.length > 0 && self.areaLocalityTextField.text.length > 0 && self.cityTextField.text.length > 0 && self.stateTextField.text.length > 0){
        self.saveButton.enabled = YES;
    }
    self.saveButton.enabled = NO;

    return YES;
}

- (IBAction)otherButtonAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn.layer valueForKey:@"isSelected"]) {
        [btn.layer setValue:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
    }
    else {
        [btn.layer setValue:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
    }
    
    [self.homeButtonOutlet setImage:[UIImage imageNamed:@"Radio_Unchecked"] forState:UIControlStateNormal];
     [self.officeButtonOutlet setImage:[UIImage imageNamed:@"Radio_Unchecked"] forState:UIControlStateNormal];
    
    [self.otherButtonOutlet setImage:[UIImage imageNamed:@"Radio_Checked"] forState:UIControlStateNormal];
    
    selectedAddressType = @"OTHER";
}

- (IBAction)homeButtonAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn.layer valueForKey:@"isSelected"]) {
        [btn.layer setValue:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
    }
    else {
        [btn.layer setValue:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
    }
    
    [self.otherButtonOutlet setImage:[UIImage imageNamed:@"Radio_Unchecked"] forState:UIControlStateNormal];
    [self.officeButtonOutlet setImage:[UIImage imageNamed:@"Radio_Unchecked"] forState:UIControlStateNormal];
    
    [self.homeButtonOutlet setImage:[UIImage imageNamed:@"Radio_Checked"] forState:UIControlStateNormal];
    
    selectedAddressType = @"HOME";
}
- (IBAction)officeButtonAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if ([btn.layer valueForKey:@"isSelected"]) {
        [btn.layer setValue:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
    }
    else {
        [btn.layer setValue:[NSNumber numberWithBool:NO] forKey:@"isSelected"];
    }
    
    [self.otherButtonOutlet setImage:[UIImage imageNamed:@"Radio_Unchecked"] forState:UIControlStateNormal];
    [self.homeButtonOutlet setImage:[UIImage imageNamed:@"Radio_Unchecked"] forState:UIControlStateNormal];
    
    [self.officeButtonOutlet setImage:[UIImage imageNamed:@"Radio_Checked"] forState:UIControlStateNormal];
    
    selectedAddressType = @"OFFICE";
}
- (IBAction)shareLocationButtonAction:(id)sender {
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse
        //[CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways
        ) {
        // Will open an confirm dialog to get user's approval
        [locationManager requestWhenInUseAuthorization];
    } else {
        [locationManager startUpdatingLocation];
        
        //Will update location immediately
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"We are currently not able to detect your location. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
    [locationManager stopUpdatingLocation];
    locationManager = nil;
     [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;

    // Reverse Geocoding
    NSLog(@"Resolving the Address");
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            _pinCodeTextField.text = placemark.postalCode;
            _flatNumberTextField.text = placemark.subThoroughfare;
            _areaLocalityTextField.text = [NSString stringWithFormat:@"%@, %@", placemark.thoroughfare, placemark.subLocality];
            _stateTextField.text = placemark.administrativeArea;
            _cityTextField.text = placemark.subAdministrativeArea;
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            latitudeValue = coordinate.latitude;
            longitudeValue = coordinate.longitude;
           
        } else {
            NSLog(@"%@", error.debugDescription);
        }
        [locationManager stopUpdatingLocation];
        locationManager = nil;
         [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    } ];
    
    
}
@end
