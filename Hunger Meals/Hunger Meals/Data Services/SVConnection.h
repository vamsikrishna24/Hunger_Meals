//
//  SVConnection.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 1/13/16.
//

#import <Foundation/Foundation.h>
#import "SVRequest.h"
@interface SVConnection : NSObject

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
/*!
 @method
 
 @abstract  Start urlrequest with SVConnection using blocks
 
 @param urlRequest is configureble request class of SVRequest
 
 */

+(void)startwithrequest:(SVRequest*)urlRequest usingblock:(void(^)(NSData *data, NSHTTPURLResponse *response,NSError *error))block;

-(void)startwithrequest:(SVRequest*)urlRequest usingblock:(void(^)(NSData *data, NSHTTPURLResponse *response,NSError *error))block;

/*!
 @method
 
 @abstract  Cancel service request with allocated object
 
 */

+(void)cancelrequest;
-(void)cancelrequest;

/*!
 @method
 
 @abstract  Cancel all the requests under SVConnection
 
 */

+(void)cancelAllrequest;
-(void)cancelAllrequest;

@end
