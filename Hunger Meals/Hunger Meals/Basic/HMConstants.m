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
NSString * const kCartDataURL = @"%@/currentcart?token=%@";
NSString * const kAddToCartURL = @"%@/savecart?token=%@";
NSString * const kUpdateCartURL = @"%@/cart/%@?token=%@";
NSString * const kAddCoupenCode = @"%@/getcouponvalue";
NSString * const kOTPGeneration = @"%@/generateotp";
NSString * const kOTPVerification = @"%@/verifyotp";
NSString * const kLocation = @"%@/locations";
NSString * const kMonthlyproducts = @"%@/getmonthlyproducts";
NSString * const kCurrentmealplan = @"%@/currmealplan";
NSString * const kCurrentActiveOrders = @"%@/currentactiveorders";
NSString * const kCurries = @"%@/products/category/curries?token=%@";;

NSString * const kUserLoginURL = @"%@/login";
NSString * const kUserSignUpURL = @"%@/jwcreate";
NSString * const kSocialSignUpURL = @"%@/jwsocialauthenticate";
NSString * const kGetLocationIDURL = @"%@/location?token=%@";
NSString * const kSyncUserLocation = @"%@/userlocation?token=%@";

#pragma -mark Other constants
NSString * const kEmptyString = @"";
NSString * const kEmptyValue = @" - ";
NSString * const kIndicatorTitle = @"Please Wait...";
NSString * const kIndicatorTitleSaving = @"Saving...";
NSString * const kNoInternetError = @"No internet connection.";
NSString * const kToken = @"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOjM2LCJpc3MiOiJodHRwczpcL1wvaG1lYWxzYXBpLnN1a29yLmluXC9hcGlcL3YxXC9sb2dpbiIsImlhdCI6MTQ3NDg3MjQyNCwiZXhwIjoxNDc0ODc2MDI0LCJuYmYiOjE0NzQ4NzI0MjQsImp0aSI6IjdkNGIwYWJiOTBlNTZjNDJjNDcxOTU3ZjQ1YjYwNjQ3In0.75QvRODahOpAlg2LMYELcOb1i9jGv9ThtNOTLyLpaOk";

#pragma Amazon URL
NSString * const imageAmazonlink = @"https://s3.ap-south-1.amazonaws.com/hungermeals/dishes/";


@end
