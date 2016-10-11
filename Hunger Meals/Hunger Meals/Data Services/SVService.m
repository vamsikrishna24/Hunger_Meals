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
            NSDictionary *resultDict = [dictResult objectForKey:@"data"];
            resultBlock([self parseUserLoginData:dictResult]);
        }
        else{
            resultBlock(nil);
        }
    }];
}


#pragma QuickBites
- (void)getQuickBitesProductsDataUsingBlock:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    NSString *url = [NSString stringWithFormat:kQuickBitesDataURL, HTTP_DATA_HOST,token];
    
    [self sendGetRequest:url usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                [self signOut];
                
            }
            resultBlock([self parseProductsData:dictResult]);
        }
        else{
            resultBlock(nil);
        }
    }];
}

#pragma southIndian
- (void)getSouthIndianProductsDataUsingBlock:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    NSString *url = [NSString stringWithFormat:kSouthIndianBitesDataURL, HTTP_DATA_HOST,token];
    
    [self sendGetRequest:url usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                [self signOut];
            }
            resultBlock([self parseProductsData:dictResult]);
        }
        else{
            resultBlock(nil);
        }
    }];
}
#pragma NorthIndian
- (void)getNorthIndianProductsDataUsingBlock:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    NSString *url = [NSString stringWithFormat:kNorthIndianBitesDataURL, HTTP_DATA_HOST,token];
    
    [self sendGetRequest:url usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                [self signOut];
                
            }
            resultBlock([self parseProductsData:dictResult]);
        }
        else{
            resultBlock(nil);
        }
    }];
}

#pragma addon
- (void)getAddOnProductsDataUsingBlock:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSData *userdataEncoded = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserData"];
    UserData *userDataObject = [NSKeyedUnarchiver unarchiveObjectWithData:userdataEncoded];
    
    NSString *token = userDataObject.token;
    NSString *url = [NSString stringWithFormat:kAddOnBitesDataURL, HTTP_DATA_HOST,token];
    
    [self sendGetRequest:url usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                [self signOut];
                
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
            resultBlock([self parseProductsData:dictResult]);
        }
        else{
            resultBlock(nil);
        }
    }];
}


#pragma currmealplan
- (void)getcurrmealplanusingBlock:(void(^)(NSMutableArray *resultArray))resultBlock {
    
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
            resultBlock([self parseCartData:dictResult]);
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
        
            //resultBlock([self parseArrayProductsData:(NSMutableArray *)dictResult]);
            resultBlock((NSMutableArray *)dictResult);
        }
        else{
            resultBlock(nil);
        }
    }];
}

- (void)getLocationID:(NSDictionary *)params usingBlock :(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSString *url = [NSString stringWithFormat:kGetLocationIDURL, HTTP_DATA_HOST];
    
    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            NSString *tokenString = [dictResult valueForKey:@"error"];
            if([tokenString isEqualToString:@"Token is Expired"]){
                [self signOut];
                
            }
            resultBlock([self parseUserLoginData:dictResult]);
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
          //  NSString *resultMessage = [resultDict objectForKey:@"message"];
            
            resultBlock(resultDict);
        }
        else{
            resultBlock(nil);
        }
    }];
}


//-(void)couponCode:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock{
//
//    
//    NSString *url = [NSString stringWithFormat:kAddCoupenCode, HTTP_DATA_HOST];
//    
//    [self sendRequest:url Perameters:dict usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
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
    return parsedArray;
}

- (NSMutableArray *)parseProductsData:(NSMutableArray *)array {
    NSError *error = nil;
    NSDictionary *dict = (NSDictionary *)array;
    NSArray *resultArr = [dict valueForKeyPath:@"data"];
    NSMutableArray *parsedArray = [Product arrayOfModelsFromDictionaries:resultArr error:&error];
    return parsedArray;
}

- (NSMutableArray *)parseArrayProductsData:(NSMutableArray *)array {
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
   // NSError *error = nil;
    NSDictionary *dict = (NSDictionary *)array;
    NSMutableArray *resultArr = [dict valueForKeyPath:@"data"];
   // NSMutableArray *parsedArray = [Product arrayOfModelsFromDictionaries:resultArr error:&error];
    return resultArr;
}
- (NSMutableArray *)parseCartData:(NSMutableArray *)array {
    NSError *error = nil;
    NSDictionary *dict = (NSDictionary *)array;
    NSArray *resultArr = [dict valueForKeyPath:@"data.data"];
    NSMutableArray *parsedArray = [CartItem arrayOfModelsFromDictionaries:resultArr error:&error];
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
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [[GIDSignIn sharedInstance] signOut];
    [APPDELEGATE showInitialScreen];

}
@end
