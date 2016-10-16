//
//  HMInviteViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 16/10/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMInviteViewController.h"
#import "ProjectConstants.h"

@interface HMInviteViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation HMInviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"User Name" attributes:@{NSForegroundColorAttributeName: APPLICATION_COLOR}];
    [self.emailTextField setValue:[UIFont fontWithName: @"Roboto-Light" size: 13] forKeyPath:@"_placeholderLabel.font"];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.emailTextField.frame.size.height - 1, self.emailTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:159.0f/255.0f green:159.0f/255.0f blue:159.0f/255.0f alpha:0.5].CGColor;
    [self.emailTextField.layer addSublayer:bottomBorder];

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

@end
