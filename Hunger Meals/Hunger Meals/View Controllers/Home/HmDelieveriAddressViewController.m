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

}

@end

@implementation HmDelieveriAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    savedLocationIDs = [[NSMutableArray alloc] init];

    [self textFieldProperties];
    
    [self TextFieldsFonts];
    self.title = @"Delivery address";
    [self.homeButtonOutlet.layer setValue:[NSNumber numberWithBool:YES] forKey:@"isSelected"];
    selectedAddressType = @"HOME";
   // self.proceedToCheckOutButtonOutlet.enabled = NO;
    
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
    UIColor *color = [UIColor colorWithRed:237.0f/255.0f green:140.0f/255.0f blue:37.0f/255.0f alpha:0.5];
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
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.cityTextField.text, @"name", self.cityTextField.text, @"city", self.areaLocalityTextField.text, @"sublocation",  self.flatNumberTextField.text, @"address", @12.9317,  @"lat", @77.6227, @"lng", self.pinCodeTextField.text, @"zip", @"userlocation", @"type", nil];
    SVService *service = [[SVService alloc] init];
    [service getLocationID:dict usingBlock:^(NSString *locationId) {
        if (locationId != nil || ![locationId isEqualToString:@""]) {
            [self syncLocationForUser:locationId];
            [savedLocationIDs addObject:locationId];
        }
    }];
}

- (void)syncLocationForUser:(NSString *)locationID{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: locationID, @"location_id", nil];
    SVService *service = [[SVService alloc] init];
    [service syncLocationToUserAccount:dict usingBlock:^(NSString *resultMessage) {
        
        if (resultMessage != nil || ![resultMessage isEqualToString:@""]) {
            NSLog(@"%@", resultMessage);
            
        }
        
    }];
    
}


- (IBAction)proceedToCheckoutAction:(id)sender {
    [self saveLocation];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ToDeliverySelection"]){
        HMPaymentTypeSelectionViewController *paymentVC = (HMPaymentTypeSelectionViewController *)segue.destinationViewController;
        paymentVC.PaymentAmountString = self.PaymentAmountString;
    }
}

//#pragma Mark - TextField Delegate methods
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    
//    if(self.pinCodeTextField.text.length > 0 && self.deliveryAddressTextFiels.text.length > 0 && self.flatNumberTextField.text.length > 0 && self.areaLocalityTextField.text.length > 0 && self.cityTextField.text.length > 0 && self.stateTextField.text.length > 0){
//        self.proceedToCheckOutButtonOutlet.enabled = YES;
//    }
//    self.proceedToCheckOutButtonOutlet.enabled = NO;
//
//    return YES;
//}
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
@end
