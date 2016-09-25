//
//  Constants.m
//  Hunger Meals
//
//  Created by SivajeeBattina on 8/29/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "HMConstants.h"

@implementation HMConstants

#pragma -mark API Calls

NSString * const kProductsDataURL = @"%@/products";
NSString * const kCreateUserDataURL = @"%@/user";
NSString * const kUserDataURL = @"%@/login?email=%@&password=%@";
NSString * const kQuickBitesDataURL = @"%@/products/category/qbites?token=%@";
NSString * const kNorthIndianBitesDataURL = @"%@/products/category/nindian?token=%@";
NSString * const kSouthIndianBitesDataURL = @"%@/products/category/sindian?token=%@";
NSString * const kAddOnBitesDataURL = @"%@/products/category/addon?token=%@";

NSString * const kUserLoginURL = @"%@/login";
NSString * const kUserSignUpURL = @"%@/jwcreate";

#pragma -mark Other constants
NSString * const kEmptyString = @"";
NSString * const kEmptyValue = @" - ";
NSString * const kIndicatorTitle = @"Please Wait...";
NSString * const kIndicatorTitleSaving = @"Saving...";
NSString * const kNoInternetError = @"No internet connection.";
NSString * const kToken = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjM2LCJpc3MiOiJodHRwczpcL1wvaG1lYWxzYXBpLnN1a29yLmluXC9hcGlcL3YxXC9sb2dpbiIsImlhdCI6MTQ3NDgxMjQ1MCwiZXhwIjoxNDc0ODE2MDUwLCJuYmYiOjE0NzQ4MTI0NTAsImp0aSI6IjQ5MDE2NzMyYzVmNjNmYmUwM2M3YzJiNWM5ODRhZGRmIn0.NKqYwGV5aPkupMJRzHUgF7qTts6oUAeHI8r5scriI-c";

@end
