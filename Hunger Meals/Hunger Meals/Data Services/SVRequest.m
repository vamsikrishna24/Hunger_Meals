//
//  SVRequest.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 1/13/16.
//

#import "SVRequest.h"
#import "SVService.h"
#import "UserData.h"

#define SV_APPLICATION_JSON @"application/json"
#define SV_MULTIPART_FORM(boundry) [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundry]
#define SV_Key_Content_Type @"Content-Type"
#define kAUTHORIZATION @"Authorization"
#define TIMEOUT 30

@implementation SVRequest

-(id)init
{
    self = [super init];
    
    //[self addValue:[CPASession sessionID] forHTTPHeaderField:CPA_key_header_session];
    
    return self;
}

#pragma mark -- Service Requests
-(void)setGetMethodwithURL:(NSString*)urlString WithFilter:(NSString *)filterString
{
    
    [self addValue:[NSString stringWithString:filterString] forHTTPHeaderField:@"filter"];
    [self setGetMethodwithURL:urlString];


}
-(void)setGetMethodwithURL:(NSString*)urlString
{
    [self setURL:[NSURL URLWithString:urlString]];
    [self setHTTPMethod:@"GET"];
//    [self addValue:[CPAUser accessTocken] forHTTPHeaderField:kAUTHORIZATION];
}
-(void)setGetMethodAuthwithURL:(NSString*)urlString
{
    [self setURL:[NSURL URLWithString:urlString]];
    [self setHTTPMethod:@"GET"];
    [self addValue:[UserData getAccessToken] forHTTPHeaderField:kAUTHORIZATION];
}
-(void)setDeleteMethodwithURL:(NSString*)urlString
{
    [self setURL:[NSURL URLWithString:urlString]];
    [self setHTTPMethod:@"DELETE"];
//    [self addValue:[CPAUser accessTocken] forHTTPHeaderField:kAUTHORIZATION];
}

//-(void)setGetMethodwithURL:(NSString*)urlString WithBody:(NSDictionary *)dictParams
//{
//    NSError *err;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictParams
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&err];
//
//    
//    [self setURL:[NSURL URLWithString:urlString]];
//    [self setCachePolicy:NSURLRequestReloadIgnoringCacheData];
//    [self setTimeoutInterval:30];
//    
//    [self setHTTPBody:jsonData];
//    [self setHTTPMethod:@"GET"];
//    
//    [self addValue:[CPAUser accessTocken] forHTTPHeaderField:kAUTHORIZATION];
//}

-(void)setPostMethodWithDict:(NSDictionary*)dictParams andURL:(NSString*)urlString
{
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictParams
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&err];
    [self setURL:[NSURL URLWithString:urlString]];
    [self setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [self setTimeoutInterval:TIMEOUT];
    
    [self setHTTPBody:jsonData];
    
    [self addValue:SV_APPLICATION_JSON forHTTPHeaderField: SV_Key_Content_Type];
    [self setHTTPMethod:@"POST"];
}

-(void)setASMXPostMethodWithDict:(NSDictionary*)dictParams andURL:(NSString*)urlString andMethod:(NSString *)methodName;
{
    
    NSError *error;
    NSString *jsonString;
    
    if (dictParams) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictParams
                                                           options:
                            NSJSONWritingPrettyPrinted
                                                             error:&error];
       jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             " <%@ xmlns=\"http://tempuri.org/\">\n"
                             "<json>%@</json>\n"
                             "</%@>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n",methodName,jsonString,methodName];
    
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [self setURL:[NSURL URLWithString:urlString]];
    [self addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self addValue: [NSString stringWithFormat:@"http://tempuri.org/%@",methodName] forHTTPHeaderField:@"SOAPAction"];
    [self addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [self setHTTPMethod:@"POST"];
    [self setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
}

-(void)setASMXPostMethodWithSOAPMessage:(NSString*)soapMessage andURL:(NSString*)urlString andMethod:(NSString *)methodName
{
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [self setURL:[NSURL URLWithString:urlString]];
    [self addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [self addValue: [NSString stringWithFormat:@"https://www.ourvmc.org/%@",methodName] forHTTPHeaderField:@"SOAPAction"];
    [self addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [self setHTTPMethod:@"POST"];
    [self setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
}


-(void)setPostMethodWithDictWithAuthorization:(NSDictionary*)dictParams andURL:(NSString*)urlString
{
    [self setPostMethodWithDict:dictParams andURL:urlString];
//    [self addValue:[CPAUser accessTocken] forHTTPHeaderField:kAUTHORIZATION];
    
}
-(void)setPostMethodWithDictWithBasicAuthorization:(NSDictionary*)dictParams andURL:(NSString*)urlString
{
    [self setPostMethodWithDict:dictParams andURL:urlString];
//    [self addValue:[CPAUser getBasicAuthorization] forHTTPHeaderField:kAUTHORIZATION];
    
}
-(void)setPostMethodWithBasicAuth:(NSDictionary *)dictParams andURL:(NSString*)urlString
{
    [self setPostMethodWithDict:dictParams andURL:urlString];
//    [self addValue:[CPAUser accessTocken] forHTTPHeaderField:kAUTHORIZATION];

}
-(void)setPostImageMethodWithURL:(NSString*)urlString UploadingImage:(UIImage *)image{
    
    // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
    NSString *BoundaryConstant = @"---------V2ymHFg03ehbqgZCaKO6jy";
    NSString* FileParamConstant = @"content";
    
    
    // create request
    [self setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [self setHTTPShouldHandleCookies:NO];
    [self setTimeoutInterval:TIMEOUT];
    [self setHTTPMethod:@"POST"];
    
    
    // set Content-Type in HTTP header
    NSString *contentType = SV_MULTIPART_FORM(BoundaryConstant);
    [self setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add image data
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.png\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    NSURL* requestURL = [NSURL URLWithString:urlString];
    
    // setting the body of the post to the reqeust
    [self setHTTPBody:body];
    
    
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [self setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [self setURL:requestURL];
    
}


-(void)setPutMethodWithDict:(NSDictionary*)dictParams andURL:(NSString*)urlString
{
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictParams
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&err];
    [self setURL:[NSURL URLWithString:urlString]];
    [self setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [self setTimeoutInterval:TIMEOUT];
    [self setHTTPBody:jsonData];
    
    
    [self addValue:SV_APPLICATION_JSON forHTTPHeaderField: SV_Key_Content_Type];
    [self setHTTPMethod:@"PUT"];
}

-(void)setDeleteMethodWithDict:(NSDictionary*)dictParams andURL:(NSString*)urlString
{
    NSError *err;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictParams
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&err];
    [self setURL:[NSURL URLWithString:urlString]];
    [self setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [self setTimeoutInterval:TIMEOUT];
    [self setHTTPBody:jsonData];
    
    
    [self addValue:SV_APPLICATION_JSON forHTTPHeaderField: SV_Key_Content_Type];
    [self setHTTPMethod:@"DELETE"];
}
@end
