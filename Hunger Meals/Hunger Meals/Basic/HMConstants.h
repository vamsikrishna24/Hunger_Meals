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
extern NSString * const kQuickBitesDataURL;
extern NSString * const kNorthIndianBitesDataURL;
extern NSString * const kSouthIndianBitesDataURL;
extern NSString * const kAddOnBitesDataURL;
extern NSString * const kCartDataURL;
extern NSString * const kAddToCartURL;
extern NSString * const kUpdateCartURL;
extern NSString * const kDeleteCartURL;

extern NSString * const kUserLoginURL;
extern NSString * const kUserSignUpURL;
extern NSString * const kAddCoupenCode;


#pragma -mark Other constants
extern NSString * const kEmptyString;
extern NSString * const kEmptyValue;
extern NSString * const kIndicatorTitle;
extern NSString * const kIndicatorTitleSaving;
extern NSString * const kNoInternetError;
extern NSString * const kToken;

#pragma Amazon URL
extern NSString * const imageAmazonlink;


@end
