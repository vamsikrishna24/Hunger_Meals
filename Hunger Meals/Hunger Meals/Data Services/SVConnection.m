//
//  SVConnection.m
//  Hunger Meals
//
//  Created by SivajeeBattina on 1/13/16.
//

#import "SVConnection.h"
#import "BTAlertController.h"

@interface SVConnection() <NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

@end

NSURLSessionDataTask *sessionDataTask;
NSMutableArray *connections;

@implementation SVConnection

+(void)startwithrequest:(SVRequest *)urlRequest usingblock:(void(^)(NSData *data, NSHTTPURLResponse *response,NSError *error))block;
{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate:nil delegateQueue: [NSOperationQueue mainQueue]];
    
    sessionDataTask =[delegateFreeSession dataTaskWithRequest:urlRequest
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                
                                                
                                                if (data)
                                                {
                                                    if (block) {
                                                        
                                                        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                        
                                                        NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse*)response;
                                                        block(result,httpresponse,error);
                                                    }
                                                }
                                                else
                                                {
                                                    if (block) {
                                                        
                                                        NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse*)response;
                                                        block(nil,httpresponse,error);
                                                    }
                                                }
                                                
                                                
                                            }];
    
    [sessionDataTask resume];
    
    
}

-(void)startwithrequest:(SVRequest*)urlRequest usingblock:(void(^)(NSData *data, NSHTTPURLResponse *response,NSError *error))block;
{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    self.dataTask =[delegateFreeSession dataTaskWithRequest:urlRequest
  completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
      
      if (data.length >0)
      {
          if (block) {
              
              NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse*)response;
              NSLog(@"%ld",(long)[httpresponse statusCode]);
              if (error == nil) {
                  [self  returnBlockErrorwithString:data Response:httpresponse Error:error usingblock:block];
              }
              else
                  block(data,httpresponse,error);
          }
      }
      else
      {
          if (block) {
              
              NSHTTPURLResponse *httpresponse = (NSHTTPURLResponse*)response;
              NSLog(@"response:%ld", (long)[httpresponse statusCode]);
              if (error == nil) {
                  [self  returnBlockErrorwithString:data Response:httpresponse Error:error usingblock:block];
              }
              else
                  block(data,httpresponse,error);
          }
      }
      
      
      
      
  }];
    
    [self.dataTask resume];
    
    
}

+(void)cancelrequest;
{
    
}
-(void)cancelrequest;
{
    
}

/*!
 @method
 
 @abstract  Cancel all the requests under SVConnection
 
 */

+(void)cancelAllrequest;
{
    
}
-(void)cancelAllrequest;
{
    
}


-(void)returnBlockErrorwithString:(NSData*)data  Response:(NSHTTPURLResponse*)httpResponse  Error:(NSError *)error usingblock:(void(^)(NSData *data, NSHTTPURLResponse *response,NSError *error))block;
{

    NSString *messageString;
    switch ([httpResponse statusCode]) {
        case 403:
        {
     //       messageString = [CPAMessage messageforkey:MESSAGE_ACCESS_DENIED];
        }
            break;
            
        case 400:
        {
       //     messageString = [CPAMessage messageforkey:MESSAGE_SERVICE_FAILED];
        }
            break;
       case 500:
        {
                block(data,httpResponse,error);
                return;
        }
            break;
            
        default:
        {
                block(data,httpResponse,error);
                return;
            
        }
            break;
    }
 
    NSError *Customerror = [NSError errorWithDomain:@"Error" code:500 userInfo:nil];
    [self showAlert:messageString];

  block(data,httpResponse,Customerror);

}

-(void)showAlert:(NSString *)messageString
{
    [BTAlertController showAlertWithMessage: messageString andTitle:@"Alert" andOkButtonTitle:@"Ok" andCancelTitle:nil andtarget:self andAlertCancelBlock:^{
        
    } andAlertOkBlock:^(NSString *userName) {
        
    }];
}

@end
