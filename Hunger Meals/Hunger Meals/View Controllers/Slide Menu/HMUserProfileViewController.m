//
//  HMUserProfileViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 16/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMUserProfileViewController.h"
#import "UserData.h"


@interface HMUserProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@end

@implementation HMUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailLabel.text = [UserData email];
    self.emailLabel.font = [UIFont fontWithName:@"Helvetica-light" size:14];
    self.phoneNumberLabel.font = [UIFont fontWithName:@"Helvetica-light" size:14];
   // self.phoneNumberLabel.text = [UserData phonNumber];
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
- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
