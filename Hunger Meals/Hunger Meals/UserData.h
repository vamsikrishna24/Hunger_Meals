//
//  UserData.h
//  Hunger Meals
//
//  Created by Uber - Sivajee Battina on 22/09/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSonModel.h"

@interface UserData : JSONModel
{
    NSString *token;
    NSString *id;
    NSString *name;
    NSString *email;
    NSString *phone_no;
    NSString *role_id;
    NSString *active;
    NSString *created_at;
    NSString *updated_at;
}

@property (nonatomic, retain) NSString<Optional> *token;
@property (nonatomic, strong) NSString<Optional> *id;
@property (nonatomic, retain) NSString<Optional> *name;
@property (nonatomic, retain) NSString<Optional> *email;
@property (nonatomic, retain) NSString<Optional> *phone_no;
@property (nonatomic, retain) NSString<Optional> *role_id;
@property (nonatomic, retain) NSString<Optional> *active;
@property (nonatomic, retain) NSString<Optional> *created_at;
@property (nonatomic, retain) NSString<Optional> *updated_at;

+ (NSString *)getAccessToken;

+ (NSString *)userName;
+ (NSString *)email;
+ (NSString *)phonNumber;

@end
