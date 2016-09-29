//
//  SVRequest.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 1/13/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SVRequest : NSMutableURLRequest

/*!
 @method
 
 @abstract  Create get method for request
 
 @param urlString is request url for server connection
 */

-(void)setGetMethodwithURL:(NSString*)urlString;

///*!
// @method
// 
// @abstract  Create get method for request
// 
// @param urlString is request url for server connection, dictParams to get data
// */
//
//-(void)setGetMethodwithURL:(NSString*)urlString WithBody:(NSDictionary *)dictParams;


/*!
 @method
 
 @abstract  Create get method for request
 
 @param urlString , filter sting as body for ticketis request url for server connection, dictParams to get data
 */
-(void)setGetMethodwithURL:(NSString*)urlString WithFilter:(NSString *)filterString;

/*!
@method

@abstract  Create post method for request

@param urlString is request url for server connection
contentType is the mention type except "application/json"
authorization with tocken
*/
-(void)setPostMethodWithDictWithAuthorization:(NSDictionary*)dictParams andURL:(NSString*)urlString;

-(void)setASMXPostMethodWithDict:(NSDictionary*)dictParams andURL:(NSString*)urlString andMethod:(NSString *)methodName;

-(void)setASMXPostMethodWithSOAPMessage:(NSString*)soapMessage andURL:(NSString*)urlString andMethod:(NSString *)methodName;
/*!
 @method
 
 @abstract  Create post method for request
 
 @param urlString is request url for server connection
 contentType is the mention type except "application/json"
 authorization with tocken
 */

-(void)setPostMethodWithDictWithBasicAuthorization:(NSDictionary*)dictParams andURL:(NSString*)urlString;

/*!
 @method
 
 @abstract  Create Post method for request
 
 @param urlString is request url for server connection, image which need to upload into server, Authoriztion bool to check need to send autorization token or not
 
 */

-(void)setPostImageMethodWithURL:(NSString*)urlString UploadingImage:(UIImage *)image;
/*!
 @method
 
 @abstract  Create post method for request
 
 @param urlString is request url for server connection,
 
 */

-(void)setPostMethodWithDict:(NSDictionary*)dictParams andURL:(NSString*)urlString;


/*!
 @method
 
 @abstract  Create delete method for request
 
 @param urlString is request url for server connection
 
 */

-(void)setDeleteMethodwithURL:(NSString*)urlString;

/*!
 @method
 
 @abstract  Create PUT method for request
 
 @param urlString is request url for server connection,
 
 */
-(void)setPutMethodWithDict:(NSDictionary*)dictParams andURL:(NSString*)urlString;

-(void)setDeleteMethodWithDict:(NSDictionary*)dictParams andURL:(NSString*)urlString;

-(void)setGetMethodAuthwithURL:(NSString*)urlString;


@end

