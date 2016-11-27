//
//  HMAddressViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 07/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMAddressViewController.h"
#import "HMSettingsTableViewCell.h"
#import "HMAddressTableViewCell.h"
#import "SVService.h"


@interface HMAddressViewController (){
    MTGenericAlertView *locationPopup;

}
@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;
@property (strong, nonatomic)  UITextView *addressTextView;
@property (strong, nonatomic) IBOutlet UIView *seenDocView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButtonOutlet;
@property (weak, nonatomic) IBOutlet UIButton *saveButtonOutlet;
- (IBAction)saveButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;

@end

@implementation HMAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Address";
    [self getLocations];
    self.addressesArray = [NSMutableArray new];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.addressesArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"AddressViewController";
    HMAddressTableViewCell *cell = [self.settingsTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.addressTableviewTextView.textAlignment = NSTextAlignmentLeft;
    
    cell.addressTableviewTextView.text = self.addressesArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
      
    }
}


- (void)getLocations {
    
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    
    SVService *service = [[SVService alloc] init];
    
    [service getLocationsDataUsingBlock:^(NSMutableArray *resultArray) {
        //[_instancesArray addObject: @{@"address":@"Banglore"}];
        if (resultArray != nil || resultArray.count != 0) {
            for(NSDictionary *addressDict in resultArray ){
                [self.addressesArray addObject:[addressDict valueForKeyPath:@"location.address"]];
            }
  
        }
        [self.settingsTableView reloadData];
         [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}

- (void) saveLocation:(NSString *)address{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: @"Koramanagala", @"name", @"Banglore", @"city", @"Birla", @"sublocation",  address, @"address", @12.9317,  @"lat", @77.6227, @"lng", @560030, @"zip", @"userlocation", @"type", nil];
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    SVService *service = [[SVService alloc] init];
    [service getLocationID:dict usingBlock:^(NSString *locationId) {
        
        if (locationId != nil || ![locationId isEqualToString:@""]) {
            [self syncLocationForUser:locationId];

        }
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
        [locationPopup close];

    }];
    
}
-(void)alert{

    
    locationPopup = [[MTGenericAlertView alloc] initWithTitle:@"Add new address" titleColor:[UIColor orangeColor] titleFont:nil backgroundImage:nil];
    
    //Add close button only to handle close button action. Other wise by default close button will be added.

    locationPopup.isPopUpView = YES;
    [locationPopup setCustomInputView:self.seenDocView];
    [locationPopup show];
    
}
- (void)syncLocationForUser:(NSString *)locationID{
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: locationID, @"location_id", nil];
    SVService *service = [[SVService alloc] init];
    [service syncLocationToUserAccount:dict usingBlock:^(NSString *resultMessage) {
        
        if (resultMessage != nil || ![resultMessage isEqualToString:@""]) {
            NSLog(@"%@", resultMessage);
            [self.addressesArray addObject:self.textView.text];
            [self.settingsTableView reloadData];
            
        }
        
    }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)addAddressbutton:(id)sender {
    [self alert];

}

- (IBAction)saveButtonAction:(id)sender {
    NSString *address = self.textView.text;
    if (address.length>1) {
        [self saveLocation:address];
    }
}

- (IBAction)cancelButtonAction:(id)sender {
    [locationPopup close];

}
@end
