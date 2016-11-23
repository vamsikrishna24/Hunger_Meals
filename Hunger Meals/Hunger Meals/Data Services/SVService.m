//
//  SVService.m
//  Hunger Meals
//
//  Created by SivajeeBattina on 1/13/16.
//

#import "SVService.h"
#import "SVConnection.h"
#import "SVRequest.h"
#import "HMConstants.h"
#import "Utility.h"
#import "Fonts.h"
#import "MTGenericAlertView.h"
#import "MBProgressHUD.h"
#import "SVXMLParser.h"
#import "Product.h"
#import "UserData.h"
#import "CartItem.h"
#import "BTAlertController.h"
#import "Itemlist.h"
#import "AppDelegate.h"
#import "ProjectConstants.h"
#import "Itemlist.h"
#import "OrderDetails.h"


@interface SVService()

/*!
 *  @property delegate
 *
 *  @discussion This delegate is used to connecting to the object
 *
 */
@property (nonatomic, assign) id delegate;


/*!
 *  @property successblock
 *
 *  @discussion This successblock is used to get the current running block obj
 *
 */

@property (nonatomic,copy) SuccessBlock successblock;


/*!
 *  @property urlConnection
 *
 *  @discussion This urlConnection is to create URL connection for the service request
 *
 */
@property (nonatomic, strong) SVConnection *urlConnection;


@end

@implementation SVService

- (id) init {
    self = [super init];
    if (self == nil)
        return nil;
    
    canShowAlert = true;
    
    return self;
}

#pragma mark -- REST Services

- (void)getProductsDataUsingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSString *url = [NSString stringWithFormat:kCreateUserDataURL, HTTP_DATA_HOST];
    
    [self sendGetRequest:url usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            resultBlock([self parseProductsData:dictResult]);
        }
        else{
            resultBlock(nil);
        }
    }];
}

#pragma User authentication 

- (void)loginUserWithDict:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSString *url = [NSString stringWithFormat:kUserLoginURL, HTTP_DATA_HOST];
    
    [self sendRequest:url Perameters:dict usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            resultBlock([self parseUserLoginData:dictResult]);
        }
        else{
            NSString *error = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            resultBlock(nil);
        }
    }];
}

#pragma User authentication

- (void)currentUserMonthlyCartWithDict:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    
    NSString *url = [NSString stringWithFormat:kCurrentUserMonthlycart, HTTP_DATA_HOST,token];
    
    [self sendRequest:url Perameters:dict usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                [self signOut];
                
            }
            resultBlock([self parseCurrentMonthlyCartData:dictResult]);
        }
        else{
            resultBlock(nil);
        }
    }];

}

#pragma QuickBites
- (void)getQuickBitesProductsDataUsingBlock:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSString *locationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationID"];
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    NSString *token = userDataObject.token;
    NSString *urlString = [NSString stringWithFormat:kMealsProductURL, HTTP_DATA_HOST,locationID,@"qbites", token];
    [self productRequestUSingBlock:dict dataUrl:urlString usingBlock:resultBlock];
    
}

#pragma southIndian
- (void)getSouthIndianProductsDataUsingBlock:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSString *locationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationID"];
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    NSString *token = userDataObject.token;
    NSString *urlString = [NSString stringWithFormat:kMealsProductURL, HTTP_DATA_HOST,locationID,@"sindian", token];
    [self productRequestUSingBlock:dict dataUrl:urlString usingBlock:resultBlock];


}

#pragma Curries
- (void)getCurriesProductsDataUsingBlock:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    NSString *locationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationID"];
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    NSString *token = userDataObject.token;
    NSString *urlString = [NSString stringWithFormat:kMealsProductURL, HTTP_DATA_HOST,locationID,@"curries", token];
    [self productRequestUSingBlock:dict dataUrl:urlString usingBlock:resultBlock];


}
#pragma NorthIndian
- (void)getNorthIndianProductsDataUsingBlock:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSString *locationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationID"];
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    NSString *token = userDataObject.token;
    NSString *urlString = [NSString stringWithFormat:kMealsProductURL, HTTP_DATA_HOST,locationID,@"nindian", token];
    [self productRequestUSingBlock:dict dataUrl:urlString usingBlock:resultBlock];


}

#pragma addon
- (void)getAddOnProductsDataUsingBlock:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSString *locationID = [[NSUserDefaults standardUserDefaults] objectForKey:@"locationID"];
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    NSString *token = userDataObject.token;
    NSString *urlString = [NSString stringWithFormat:kMealsProductURL, HTTP_DATA_HOST,locationID,@"addons", token];
    [self productRequestUSingBlock:dict dataUrl:urlString usingBlock:resultBlock];


}

-(void)productRequestUSingBlock:(NSDictionary *)dict dataUrl:(NSString *)urlString usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    
    NSString *url = [NSString stringWithFormat:urlString, HTTP_DATA_HOST,token];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:userDataObject.token,@"token", nil];
    [self sendGetRequest:url usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
               [self newRefreshTokenDict:params usingBlock:^(NSMutableArray *resultArray) {
                   userDataObject.token = [resultArray valueForKey:@"token"];
                  [self productRequestUSingBlock:dict dataUrl:url usingBlock:^(NSMutableArray *resultArray) {
                  }];
               }];
            }
            resultBlock([self parseProductsData:dictResult]);
        }
        else{
            resultBlock(nil);
        }
    }];
}

#pragma Current-Cart
- (void)getCartDatausingBlock:(void(^)(NSMutableArray *resultArray))resultBlock {
    
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    NSString *url = [NSString stringWithFormat:kCartDataURL, HTTP_DATA_HOST,token];
    
    [self sendGetRequestWithAuth:url usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                [self signOut];
                
            }
            resultBlock([self parseCartData:dictResult]);
        }
        else{
            resultBlock(nil);
        }
    }];

}


#pragma Getmonthlyproducts
- (void)getmonthlyproductsusingBlock:(void(^)(NSMutableArray *resultArray))resultBlock {
    
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    NSString *url = [NSString stringWithFormat:kMonthlyproducts, HTTP_DATA_HOST,token];
    
    [self sendGetRequestWithAuth:url usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                [self signOut];
                
            }
            resultBlock([self parseItemsData:dictResult]);
        }
        else{
            resultBlock(nil);
        }
    }];
}


#pragma currmealplan
- (void)getcurrmealplanusingBlock:(void(^)(NSDictionary *resultDict))resultBlock{
    
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    NSString *url = [NSString stringWithFormat:kCurrentmealplan, HTTP_DATA_HOST,token];
    
    
    [self sendGetRequestWithAuth:url usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                [self signOut];
                
            }
            NSMutableArray *lunchList = [dictResult valueForKeyPath:@"data.lunchplandata.title"];
            NSMutableArray *dinnerList = [dictResult valueForKeyPath:@"data.dinnerplandata.title"];
            if (lunchList.count < 1 && dinnerList.count < 1 ){
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"MonthlyMealPlan"];
            }else{
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MonthlyMealPlan"];
            }
            resultBlock(dictResult);
        }
        else{
            resultBlock(nil);
        }
    }];
}

- (void)saveMonthlyMealPlan:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock {
    
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    NSString *url = [NSString stringWithFormat:kCurrentmealplan, HTTP_DATA_HOST,token];
    
    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            NSString *resultMsg = [dictResult valueForKeyPath:@"data.message"];
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                [self signOut];
                
            }
            resultBlock(resultMsg);
        }
        else{
            resultBlock(nil);
        }
    }];

}
#pragma forgot_Password
- (void)forgotPassword:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock {
    
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    NSString *url = [NSString stringWithFormat:kForgotPasswordURL, HTTP_DATA_HOST,token];
    
    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            NSString *resultMsg = [dictResult valueForKeyPath:@"data.message"];
            
            if([resultMsg isEqualToString: @"Validation error"]){
                 [[[UIAlertView alloc] initWithTitle:@"Validation error" message:@"The email must be a valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }else{

             [[[UIAlertView alloc] initWithTitle:@"Success" message:@"A link to reset your password has been sent on your email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            resultBlock(dictResult);
        }
else{
            resultBlock(nil);
        }
    }];
    
}
#pragma currentactiveorders
- (void)getCurrentActiveordersusingBlock:(void(^)(NSMutableArray *resultArray))resultBlock {
    
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    NSString *url = [NSString stringWithFormat:kCurrentActiveOrders, HTTP_DATA_HOST,token];
    
    [self sendGetRequestWithAuth:url usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                [self signOut];
                
            }
            resultBlock([self parseOrdersData:dictResult]);
        }
        else{
            resultBlock(nil);
        }
    }];
}
#pragma mark -- REST Services

#pragma GetLocations

- (void)getLocationsDataUsingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSString *url = [NSString stringWithFormat:kLocation, HTTP_DATA_HOST];
    [self sendGetRequestWithAuth:url usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
        
            resultBlock((NSMutableArray *)dictResult);
        }
        else{
            resultBlock(nil);
        }
    }];
}

- (void)getLocationID:(NSDictionary *)params usingBlock :(void(^)(NSString *locationId))resultBlock{
    
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    NSString *url = [NSString stringWithFormat:kGetLocationIDURL, HTTP_DATA_HOST,token];
    
    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *locationID = [dictResult valueForKeyPath:@"data.location"];
            resultBlock(locationID);
        }
        else{
            resultBlock(nil);
        }
    }];
}

#pragma NewTokenGeneration

- (void)newRefreshTokenDict:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;

    NSString *url = [NSString stringWithFormat:kRefreshTokenURL, HTTP_DATA_HOST,token];
    
    [self sendRequest:url Perameters:dict usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            resultBlock([self parseUserLoginData:dictResult]);
        }
        else{
            NSString *error = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            resultBlock(nil);
        }
    }];
}

- (void)syncLocationToUserAccount:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock{
    
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    NSString *url = [NSString stringWithFormat:kSyncUserLocation, HTTP_DATA_HOST,token];
    
    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *locationID = [dictResult valueForKeyPath:@"data.message"];
            resultBlock(locationID);
        }
        else{
            resultBlock(nil);
        }
    }];
}

#pragma InviteUser
- (void)inviteUserAccount:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock{
    
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    NSString *url = [NSString stringWithFormat:kInviteUserURL, HTTP_DATA_HOST,token];
    
    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *resultDict = [dictResult objectForKey:@"data"];
            resultBlock(resultDict);
        }
        else{
            resultBlock(nil);
        }
    }];
}


#pragma AddToCArt
- (void)addToCart:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock{
    
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    NSString *url = [NSString stringWithFormat:kAddToCartURL, HTTP_DATA_HOST,token];

    
    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                [self signOut];
                
            }
            NSDictionary *resultDict = [dictResult objectForKey:@"data"];
            NSString *resultMessage = [resultDict objectForKey:@"message"];
            
            resultBlock(resultMessage);
        }
        else{
            resultBlock(nil);
        }
    }];
}

#pragma coupon

- (void)couponCode:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock{
    
    NSString *url = [NSString stringWithFormat:kAddCoupenCode, HTTP_DATA_HOST];
    
    
    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                
                [self signOut];
                
            }
            NSString *resultDict = [dictResult objectForKey:@"data"];
            
            resultBlock(resultDict);
        }
        else{
            resultBlock(nil);
        }
    }];
}

#pragma CheckExistingUser Generation
- (void)checkExistingUser:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock{
    
    NSString *email = [params objectForKey:@"email"];
    
    NSString *url = [NSString stringWithFormat:kCheckExistingUser, HTTP_DATA_HOST, email];
    
    
    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        
        NSString *resultString = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        if (response.statusCode == 200 && result!=nil) {
           
            resultBlock(resultString);
            
        }
        else if(response.statusCode == 401){
            resultBlock(resultString);
        }
    }];
}
#pragma OTP Generation
- (void)otpGenaration:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock{
    
    NSString *url = [NSString stringWithFormat:kOTPGeneration, HTTP_DATA_HOST];
    
    
    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                [self signOut];
                
            }
            NSDictionary *resultDict = [dictResult objectForKey:@"data"];
            NSString *resultMessage = [resultDict objectForKey:@"message"];
            
            resultBlock(resultMessage);
        }
        else{
            resultBlock(nil);
        }
    }];
}

#pragma OTP Verification
- (void)otpVerification:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock{
    
    NSString *url = [NSString stringWithFormat:kOTPVerification, HTTP_DATA_HOST];
    
    
    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                [self signOut];
                
            }
            NSDictionary *resultDict = [dictResult objectForKey:@"data"];
            NSString *resultMessage = [resultDict objectForKey:@"message"];
            
            resultBlock(resultMessage);
        }
        else{
            resultBlock(nil);
        }
    }];
}

//- (void)currentCartDetails:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock{
//    
//    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
//    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
//    
//    NSString *token = userDataObject.token;
//    NSString *url = [NSString stringWithFormat:kAddToCartURL, HTTP_DATA_HOST,token];
//    
//    
//    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
//        
//        if (response.statusCode == 200 && result!=nil) {
//            
//            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//            NSDictionary *resultDict = [dictResult objectForKey:@"data"];
//            NSString *resultMessage = [resultDict objectForKey:@"message"];
//            
//            resultBlock(resultMessage);
//        }
//        else{
//            resultBlock(nil);
//        }
//    }];
//}

//- (void)deleteCartItems:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock{
//    
//    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
//    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
//    
//    NSString *token = userDataObject.token;
//    NSString *url = [NSString stringWithFormat:kDeleteCartURL, HTTP_DATA_HOST,token];
//    
//    
//    [self deleteRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
//        
//        if (response.statusCode == 200 && result!=nil) {
//            
//            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
//            NSDictionary *resultDict = [dictResult objectForKey:@"data"];
//            NSString *resultMessage = [resultDict objectForKey:@"message"];
//            
//            resultBlock(resultMessage);
//        }
//        else{
//            resultBlock(nil);
//        }
//    }];
//}


#pragma Create User

- (void)createUser:(NSDictionary *)params usingBlock :(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSString *url = [NSString stringWithFormat:kUserSignUpURL, HTTP_DATA_HOST];
    
    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            resultBlock([self parseUserLoginData:dictResult]);
        }
        else{
            resultBlock(nil);
        }
    }];
}

- (void)signupWithSocialNetwork:(NSDictionary *)params usingBlock :(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSString *url = [NSString stringWithFormat:kSocialSignUpURL, HTTP_DATA_HOST];
    
    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            resultBlock([self parseUserLoginData:dictResult]);
        }
        else{
            resultBlock(nil);
        }
    }];
}

#pragma mark -- Parsing Methods

- (NSMutableArray *)parseUserLoginData:(NSMutableArray *)array {
    NSError *error = nil;
    NSDictionary *dict = (NSDictionary *)array;
    NSDictionary *resultDict = [dict objectForKey:@"data"];
    NSString *tokenString = [resultDict objectForKey:@"token"];
    NSArray *resultArray = [NSArray arrayWithObject:[resultDict objectForKey:@"user"]];
    
    NSMutableArray *parsedArray = [UserData arrayOfModelsFromDictionaries:resultArray error:&error];
    UserData *userDataObj = parsedArray[0];
    userDataObj.token = tokenString;
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:userDataObj];
    [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"UserData"];
    return parsedArray;
}

- (NSMutableArray *)parseProductsData:(NSMutableArray *)array {
    NSError *error = nil;
    NSDictionary *dict = (NSDictionary *)array;
    NSArray *resultArr = [dict valueForKeyPath:@"data.inventory.product"];
    NSArray *pricesArr = [dict valueForKeyPath:@"data.inventory.price"];
    NSArray *quantityArr = [dict valueForKeyPath:@"data.quantity"];
    NSMutableArray *parsedArray = [Product arrayOfModelsFromDictionaries:resultArr error:&error];
    int count = 0;
    for (Product *productObj in parsedArray) {
        productObj.price = pricesArr[count];
        productObj.quantity = quantityArr[count];
        count++;
    }
    return parsedArray;
}

- (NSMutableArray *)parseMonthlyMealData:(NSMutableArray *)array {
    NSError *error = nil;
    NSMutableArray *parsedArray = [Itemlist arrayOfModelsFromDictionaries:array error:&error];
    return parsedArray;
}

- (NSMutableArray *)parseItemsData:(NSMutableArray *)array {
    NSError *error = nil;
    NSDictionary *dict = (NSDictionary *)array;
    NSArray *resultArr = [dict valueForKeyPath:@"data"];
    NSMutableArray *parsedArray = [Itemlist arrayOfModelsFromDictionaries:resultArr error:&error];
    return parsedArray;
}

- (NSMutableArray *)parseArrayProductsData:(NSMutableArray *)array {
    NSError *error = nil;
    //NSDictionary *dict = (NSDictionary *)array;
   // NSArray *resultArr = [dict valueForKeyPath:@"data"];
    NSMutableArray *parsedArray = [Product arrayOfModelsFromDictionaries:array error:&error];
    return parsedArray;
}

- (NSMutableArray *)parseCurrentMealData:(NSMutableArray *)array {
    NSError *error = nil;
    //NSDictionary *dict = (NSDictionary *)array;
    // NSArray *resultArr = [dict valueForKeyPath:@"data"];
    NSMutableArray *parsedArray = [Product arrayOfModelsFromDictionaries:array error:&error];
    return parsedArray;
}
- (NSMutableArray *)parseItemsArrayData:(NSMutableArray *)array {
    NSError *error = nil;
    //NSDictionary *dict = (NSDictionary *)array;
    // NSArray *resultArr = [dict valueForKeyPath:@"data"];
    NSMutableArray *parsedArray = [Product arrayOfModelsFromDictionaries:array error:&error];
    return parsedArray;
}
- (NSMutableArray *)parseOrdersData:(NSMutableArray *)array {
    NSError *error = nil;
    NSDictionary *dict = (NSDictionary *)array;
    NSMutableArray *resultArr = [dict valueForKeyPath:@"data"];
    NSMutableArray *parsedArray = [OrderDetails arrayOfModelsFromDictionaries:resultArr error:&error];
    return parsedArray;
}
- (NSMutableArray *)parseCartData:(NSMutableArray *)array {
    NSError *error = nil;
    NSDictionary *dict = (NSDictionary *)array;
    NSArray *resultArr = [dict valueForKeyPath:@"data.data"];
    NSMutableArray *parsedArray = [CartItem arrayOfModelsFromDictionaries:resultArr error:&error];
    return parsedArray;
}

- (NSMutableArray *)parseCurrentMonthlyCartData:(NSMutableArray *)array {
    NSError *error = nil;
    NSDictionary *dict = (NSDictionary *)array;
    NSMutableArray *resultArr = [dict valueForKeyPath:@"data.data"];
    NSMutableArray *parsedArray = resultArr;//[CartItem arrayOfModelsFromDictionaries:resultArr error:&error];
    return parsedArray;
}

#pragma mark -- Service Requests

-(void)sendRequest:(NSString *)urlString  Perameters:(NSDictionary *)perameterDict usingblock:(void(^)(id result, NSHTTPURLResponse *response, NSError *err))block{
    
    SVRequest *request = [[SVRequest alloc] init];
    
    //Add POST method to request
    [request setPostMethodWithDict:perameterDict andURL:urlString];
    
    [self initiateConnectionwithrequest:request usingblock:block];
    
}


-(void)deleteRequest:(NSString *)urlString  Perameters:(NSDictionary *)perameterDict usingblock:(void(^)(id result, NSHTTPURLResponse *response, NSError *err))block{
    
    SVRequest *request = [[SVRequest alloc] init];
    
    //Add PUT method to request
    [request setDeleteMethodWithDict:perameterDict andURL:urlString];
    
    [self initiateConnectionwithrequest:request usingblock:block];
}

-(void)sendASMXRequest:(NSString *)urlString  Parameters:(NSDictionary *)parameterDict method:(NSString *)methodName usingblock:(void(^)(id result, NSHTTPURLResponse *response, NSError *err))block{
    
    SVRequest *request = [[SVRequest alloc] init];
    
    //Add POST method to request
    [request setASMXPostMethodWithDict:parameterDict andURL:urlString andMethod:methodName];
    
    [self initiateConnectionwithrequest:request usingblock:block];
}

-(void)sendASMXRequest:(NSString *)urlString  soapMessage:(NSString *)soapMessage method:(NSString *)methodName usingblock:(void(^)(id result, NSHTTPURLResponse *response, NSError *err))block{
    
    SVRequest *request = [[SVRequest alloc] init];
    
    //Add POST method to request
    [request setASMXPostMethodWithSOAPMessage:soapMessage andURL:urlString andMethod:methodName];
    
    [self initiateConnectionwithrequest:request usingblock:block];
}

-(void)sendGetRequest:(NSString *)urlString usingblock:(void(^)(id result, NSHTTPURLResponse *response, NSError *err))block
{
    NSLog(@"requestString: %@", urlString);
    SVRequest *request = [self authenticatedRequest];
    
    if (request) {
        [request setGetMethodwithURL:urlString];
        
        [self initiateConnectionwithrequest:request usingblock:block];
    }
    else{
        block(nil,nil,nil);
    }
}

-(void)sendGetRequestWithAuth:(NSString *)urlString usingblock:(void(^)(id result, NSHTTPURLResponse *response, NSError *err))block
{
    NSLog(@"requestString: %@", urlString);
    SVRequest *request = [self authenticatedRequest];
    
    if (request) {
        [request setGetMethodAuthwithURL:urlString];
        
        [self initiateConnectionwithrequest:request usingblock:block];
    }
    else{
        block(nil,nil,nil);
    }
}


- (SVRequest *) authenticatedRequest{
    
    
    //    NSString *username = [[AppDelegate sharedApplication] username];
    //    Log(@"Trying to get stored username from previous session...%@", username);
    //    NSString *password = [[AppDelegate sharedApplication] password];
    //    Log(@"Trying to get stored password from previous session...%@", password);
    
    SVRequest *request = nil;
    
    // Create a request
    request = [[SVRequest alloc] init];
    return request;
}

#pragma mark -- initiate connection

-(void)initiateConnectionwithrequest:(SVRequest *)request  usingblock:(void(^)(NSData *data, NSHTTPURLResponse *response,NSError *error))block;
{
    self.urlConnection = [[SVConnection alloc] init];
    [self.urlConnection startwithrequest:request usingblock:block];
}

-(void)returnBlockErrorwithString:(NSString*)errorString
{
    // ERROR!
    NSMutableDictionary* details = [NSMutableDictionary dictionary];
    [details setValue:errorString forKey:NSLocalizedDescriptionKey];
    
    // populate the error object with the details
    NSError *error = [NSError errorWithDomain:@"Error" code:-1001 userInfo:details];
    
    // returning the block
    self.successblock(nil,nil,error);
}

+(NSString *)getBasicAuthorization
{
    return [NSString stringWithFormat:@"Basic %@",[SVService encodeStringTo64:[NSString  stringWithFormat:@"%@:%@",@"",@""]]];
    //return [NSString stringWithFormat:@"Basic %@",[CPAUtility encodeStringTo64:[NSString  stringWithFormat:@"%@:%@",@"cimadmin@cim.com",@"Test@1234"]]];
}

+ (NSString*)encodeStringTo64:(NSString*)fromString {
    
    NSData *plainData = [fromString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String;
    if ([plainData respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        base64String = [plainData base64EncodedStringWithOptions:kNilOptions];  // iOS 7+
    }
    return base64String;
}

-(void)signOut{
    [[NSUserDefaults standardUserDefaults] setObject: nil forKey:@"UserData"];
    [[NSUserDefaults standardUserDefaults] setBool: NO forKey:@"isLoginValid"];
    [[NSUserDefaults standardUserDefaults] setValue: nil forKey: @"selectedLocation"];
    [[NSUserDefaults standardUserDefaults] setObject: @"NO" forKey: @"isLocationSelected"];
    //[[NSUserDefaults standardUserDefaults] setObject: nil forKey: @"userData"];
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [[GIDSignIn sharedInstance] signOut];
    [APPDELEGATE showInitialScreen];

}

@end
