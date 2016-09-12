//
//  Constants.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 8/29/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <Foundation/Foundation.h>

# define HTTP_DATA_HOST @"https://hmealsapi.sukor.in/api/v1"

@interface HMConstants : NSObject

#pragma -mark API Calls
extern NSString * const kProductsDataURL;
extern NSString * const kCreateUserDataURL;
extern NSString * const kUserDataURL;


#pragma -mark Other constants
extern NSString * const kEmptyString;
extern NSString * const kEmptyValue;
extern NSString * const kIndicatorTitle;
extern NSString * const kIndicatorTitleSaving;
extern NSString * const kNoInternetError;

@end
