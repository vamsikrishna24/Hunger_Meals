//
//  UserData.m
//  Hunger Meals
//
//  Created by Uber - Sivajee Battina on 22/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "UserData.h"

@implementation UserData
@synthesize token, id, name, email, phone_no, role_id, active, created_at, updated_at;

+ (NSString *)getAccessToken {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"UserData"];
    UserData *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    NSString *bearerString = [NSString stringWithFormat:@"%@ %@",@"bearer",object.token];

    return bearerString;
}

@end
