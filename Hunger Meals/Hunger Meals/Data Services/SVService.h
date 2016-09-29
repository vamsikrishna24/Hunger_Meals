//
//  SVService.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 1/13/16.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(NSData *data , NSHTTPURLResponse *response, NSError *err);

@interface SVService : NSObject
{
    BOOL canShowAlert;
}

//Rest services
- (void)getProductsDataUsingBlock:(void(^)(NSMutableArray *resultArray))resultBlock;

- (void)getQuickBitesProductsDataUsingBlock:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock;

- (void)getNorthIndianProductsDataUsingBlock:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock;

- (void)getSouthIndianProductsDataUsingBlock:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock;

- (void)getAddOnProductsDataUsingBlock:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock;

- (void)currentCartDetails:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock;

- (void)getCartDatausingBlock:(void(^)(NSMutableArray *resultArray))resultBlock;

- (void)addToCart:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock;

- (void)createUser:(NSDictionary *)params usingBlock :(void(^)(NSMutableArray *resultArray))resultBlock;

- (void)loginUserWithDict:(NSDictionary *)dict usingBlock:(void(^)(NSMutableArray *resultArray))resultBlock;

- (void)deleteCartItems:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock;

//Service Requests

-(void)sendRequest:(NSString *)urlString  Perameters:(NSDictionary *)perameterDict usingblock:(void(^)(id result, NSHTTPURLResponse *response, NSError *err))block;

-(void)sendGetRequest:(NSString *)urlString usingblock:(void(^)(id result, NSHTTPURLResponse *response, NSError *err))block;

-(void)deleteRequest:(NSString *)urlString  Perameters:(NSDictionary *)perameterDict usingblock:(void(^)(id result, NSHTTPURLResponse *response, NSError *err))block;

-(void)sendASMXRequest:(NSString *)urlString  Parameters:(NSDictionary *)parameterDict method:(NSString *)methodName usingblock:(void(^)(id result, NSHTTPURLResponse *response, NSError *err))block;

-(void)sendASMXRequest:(NSString *)urlString  soapMessage:(NSString *)soapMessage method:(NSString *)methodName usingblock:(void(^)(id result, NSHTTPURLResponse *response, NSError *err))block;

- (void)addcouponcode:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock;

- (void)otpGenaration:(NSDictionary *)params usingBlock :(void(^)(NSString *resultMessage))resultBlock;




@end

