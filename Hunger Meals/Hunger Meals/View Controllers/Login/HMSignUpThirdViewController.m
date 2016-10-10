//
//  HMSignUpThirdViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 20/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMSignUpThirdViewController.h"
#import "BTAlertController.h"
#import "HMConstants.h"
#import "ProjectConstants.h"
#import "SVService.h"
#import "UserData.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>

@interface HMSignUpThirdViewController (){
    NSInteger numRows;
    int *count;
    NSMutableArray *indexPathsOfCells;
}

@end

@implementation HMSignUpThirdViewController
@synthesize managedObjectContext;

- (void)viewDidLoad {
    [super viewDidLoad];
    numRows = 2;
    //[self.addressTableView setTableFooterView:self.tableFooterView];
    [self.addressTableView setBackgroundColor:[UIColor clearColor]];
    self.pageIndex = 3;

    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Addresses"];
    NSMutableArray *array = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
}

- (void)showAlertWithMsg:(NSString *)msg{
    [BTAlertController showAlertWithMessage:msg andTitle:@"" andOkButtonTitle:nil andCancelTitle:@"Ok" andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        
    }];
    
}

#pragma mark - UITableView Delegate and Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *addressCellIdentifier = @"AddressTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:addressCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addressCellIdentifier];
    }

    [indexPathsOfCells addObject:indexPath];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (IBAction)skipButtonAction:(id)sender {
    [self SignUpToServer];
}

- (void)SignUpToServer{
    [self performSelectorOnMainThread:@selector(showActivityIndicatorWithTitle:) withObject:kIndicatorTitle waitUntilDone:NO];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys: self.email, @"name", self.email, @"email", self.password, @"password",  @"authenticated_user", @"role_name", self.phoneNumber,  @"phone_no", nil];
    SVService *service = [[SVService alloc] init];
    [service createUser:dict usingBlock:^(NSMutableArray *resultArray) {
        if (resultArray.count != 0 || resultArray != nil) {
            UserData *dataObject = resultArray[0];
            NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dataObject];
            [[NSUserDefaults standardUserDefaults] setObject:personEncodedObject forKey:@"UserData"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLoginValid"];
            [APPDELEGATE showInitialScreen];
        }
        [self performSelectorOnMainThread:@selector(hideActivityIndicator) withObject:nil waitUntilDone:NO];
    }];
    
}

- (IBAction)addAddressAction:(id)sender {
    [self addRow];
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
    
    UITableView *tableView = self.addressTableView;
    NSMutableSet *addressTextViews = [[NSMutableSet alloc] init];
    
    for (NSIndexPath *indexPath in indexPathsOfCells){
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        for (UITextView *textView in cell.contentView.subviews) {
            if ([textView isKindOfClass:NSClassFromString(@"UITextView")]) {
                if (![textView.text isEqualToString:@""]) {
                    [addressTextViews addObject:textView];
                }
            }
        }
    }
    
    for (UITextView *textView in addressTextViews) {
            // Create a new managed object for Address
            NSManagedObject *addressEntity = [NSEntityDescription insertNewObjectForEntityForName:@"Addresses" inManagedObjectContext:context];
            [addressEntity setValue:textView.text forKey:@"address"];
            
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
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserLogin"];
    [APPDELEGATE showInitialScreen];
    
}
-(void)addRow
{
    //ASSUMING THIS CHUNK IS CALLED FROM A LOOP
    NSIndexPath *path = [NSIndexPath indexPathForRow:numRows inSection:0];
    numRows = numRows + 1;
    [self.addressTableView beginUpdates];
    [self.addressTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationBottom];
    [self.addressTableView endUpdates];
}

@end
