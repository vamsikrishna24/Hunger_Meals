//
//  HMSignUpViewController.m
//  Hunger Meals
//
//  Created by Vamsi on 26/07/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMSignUpViewController.h"

@interface HMSignUpViewController ()

@end

@implementation HMSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mobileNumVerificationPressed:(id)sender{
    // Use your own details here
    
    NSString *twilioSID = @"AC3cfad426abd97d934a545f9595bdcad0";
    NSString *twilioSecret = @"ec688996442e481f23a9b432e2571fae";
    NSString *fromNumber = @"%2B16467834051";
    NSString *toNumber = @"%2B919703772035";
    NSString *message = @"Hey";
    
    NSString *urlString = [NSString stringWithFormat:@"https://%@:%@@api.twilio.com/2010-04-01/Accounts/%@/SMS/Messages", twilioSID,twilioSecret,twilioSID];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [[NSString stringWithFormat:@"From=%@&To=%@&Body=%@", fromNumber, toNumber, message] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURLSessionTask *sessionTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //do somethign here
        if (error == nil) {
            NSString* newStr = [[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding];
            NSLog(@"called successfully");
        }
        else{
            
        }
    }];
    
    [sessionTask resume];
    
}


@end
