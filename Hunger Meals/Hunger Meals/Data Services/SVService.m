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
#import "Reachability.h"
#import "MTGenericAlertView.h"
#import "MBProgressHUD.h"
#import "SVXMLParser.h"
#import "Product.h"


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

#pragma Create User

- (void)createUser:(NSDictionary *)params usingBlock :(void(^)(NSMutableArray *resultArray))resultBlock{
    
    NSString *url = [NSString stringWithFormat:kProductsDataURL, HTTP_DATA_HOST];
    
    [self sendRequest:url Perameters:params usingblock:^(id result, NSHTTPURLResponse *response, NSError *err) {
        
        if (response.statusCode == 200 && result!=nil) {
            
            id dictResult = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:nil];
            
            resultBlock([self parseProductsData:dictResult]);
        }
        else{
            resultBlock(nil);
        }
    }];
}
#pragma mark -- Parsing Methods

- (NSMutableArray *)parseProductsData:(NSMutableArray *)array {
    NSError *error = nil;
    NSDictionary *dict = (NSDictionary *)array;
    NSArray *resultArr = [dict valueForKeyPath:@"data.data"];
    NSMutableArray *parsedArray = [Product arrayOfModelsFromDictionaries:resultArr error:&error];
    return parsedArray;
}

#pragma mark -- Service Requests

-(void)sendRequest:(NSString *)urlString  Perameters:(NSDictionary *)perameterDict usingblock:(void(^)(id result, NSHTTPURLResponse *response, NSError *err))block{
    
    SVRequest *request = [[SVRequest alloc] init];
    
    //Add POST method to request
    [request setPostMethodWithDict:perameterDict andURL:urlString];
    
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


@end
