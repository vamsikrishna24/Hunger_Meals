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

+ (UserData *)getUserInfo {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"UserData"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
}

+ (NSString *)getAccessToken {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"UserData"];
    UserData *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    NSString *bearerString = [NSString stringWithFormat:@"%@ %@",@"bearer",object.token];

    return bearerString;
}

+ (NSString *)userName {
    UserData *user = [UserData getUserInfo];
    return user.name;
}

+ (NSString *)email {
    UserData *user = [UserData getUserInfo];
    return user.email;
}

+ (NSString *)phonNumber {
    UserData *user = [UserData getUserInfo];
    if (user.phone_no == nil || [user.phone_no  isEqual: @""]) {
        return @"";
    }
    return user.phone_no;
}


@end
