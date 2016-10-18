//
//  Constants.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 8/29/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

# define HTTP_DATA_HOST @"https://hmealsapi.sukor.in/api/v1"

@interface HMConstants : NSObject

#pragma -mark API Calls
extern NSString * const kProductsDataURL;
extern NSString * const kCreateUserDataURL;
extern NSString * const kUserDataURL;
extern NSString * const kQuickBitesDataURL;
extern NSString * const kNorthIndianBitesDataURL;
extern NSString * const kSouthIndianBitesDataURL;
extern NSString * const kAddOnBitesDataURL;
extern NSString * const kCartDataURL;
extern NSString * const kAddToCartURL;
extern NSString * const kUpdateCartURL;
extern NSString * const kDeleteCartURL;
extern NSString * const kCurries;

extern NSString * const kUserLoginURL;
extern NSString * const kUserSignUpURL;
extern NSString * const kSocialSignUpURL;
extern NSString * const kAddCoupenCode;
extern NSString * const kOTPGeneration;
extern NSString * const kOTPVerification;
extern NSString * const kLocation;
extern NSString * const kGetLocationIDURL;
extern NSString * const kSyncUserLocation;
extern NSString * const kMonthlyproducts;
extern NSString * const kCurrentmealplan;
extern NSString * const kCurrentActiveOrders;
extern NSString * const kInviteUserURL;



#pragma -mark Other constants
extern NSString * const kEmptyString;
extern NSString * const kEmptyValue;
extern NSString * const kIndicatorTitle;
extern NSString * const kIndicatorTitleSaving;
extern NSString * const kNoInternetError;
extern NSString * const kToken;

#pragma Amazon URL
extern NSString * const imageAmazonlink;

#define USER_DEFAULTS [NSUserDefaults standardUserDefaults]

#define APPDELEGATE   ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define kRadioOn @"RadioOn"
#define kRadioOff @"RadioOff"
#define kClose @"close"


@end
