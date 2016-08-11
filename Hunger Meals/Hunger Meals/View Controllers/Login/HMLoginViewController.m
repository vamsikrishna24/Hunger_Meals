//
//  HMLoginViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 11/08/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMLoginViewController.h"

@interface HMLoginViewController ()
- (IBAction)backBarButtonItemAction:(id)sender;

@end

@implementation HMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)backBarButtonItemAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
