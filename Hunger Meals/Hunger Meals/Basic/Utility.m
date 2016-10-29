//
//  Utility.m
//  Hunger Meals
//
//  Created by SivajeeBattina on 7/15/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "Utility.h"
#import <UIKit/UIKit.h>

@implementation Utility
+ (NSString *) getGenericeEmail:(NSString *)emailText;
{
    //generic email ID field has to behave in the same way (trim spaces and case insensitive)
    emailText = [[emailText stringByReplacingOccurrencesOfString:@" " withString:@""] lowercaseString];
    return emailText;
}

+ (BOOL) isEmptywithspaces:(NSString*)str
{
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([str length]==0) {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL) isValidatePassword:(NSString *) password
{
    NSCharacterSet *upperCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZ"];
    NSCharacterSet *lowerCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyz"];
    NSString *specialCharacterString = @"!~`@#$%^&*-+();:={}[],.<>?\\/\"\'";
    NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacterString];
    
    
    //NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    if ( [password length]<8 || [password length]>18 )
        return NO;  // too long or too short
  /*  NSRange rang;
    rang = [password rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    if ( !rang.length )
        return NO;  // no letter
    rang = [password rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ( !rang.length )
        return NO;  // no number;
    rang = [password rangeOfCharacterFromSet:specialCharacterSet];
    if (!rang.length) {
        return NO;
    }
    rang = [password rangeOfCharacterFromSet:upperCaseChars];
    if ( !rang.length )
        return NO;  // no uppercase letter;
    rang = [password rangeOfCharacterFromSet:lowerCaseChars];
    if ( !rang.length )
        return NO;  // no lowerCase Chars; */
    return YES;
}
+(BOOL)isUserNameValidation:(NSString*)userName{
    //[A-Za-z0-9.-]
    //    return YES; // remove in feature;
    NSString *specialCharacterString = @"!~`@#$%^&*-+();:={}[],.<>?\\/\"\'";
    NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacterString];
    NSCharacterSet *upperCaseChars = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLKMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
    if (userName.length<6) {
        return NO;
    }
    NSRange rang;
    rang = [userName rangeOfCharacterFromSet:specialCharacterSet];
    if (rang.length) {
        return NO;
    }
    //    rang = [userName rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]];
    //    if ( !rang.length )
    //      //  return NO;  // no number;
    //    rang = [userName rangeOfCharacterFromSet:upperCaseChars];
    //    if ( !rang.length )
    //  //      return NO;
    return YES;
}

+ (BOOL) isValidateEmail:(NSString *) emailString
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailString];
    
}

+ (BOOL) isValidateOTP:(NSString *) otpString
{
    NSScanner *scanner = [NSScanner scannerWithString:otpString];
    BOOL isNumeric = [scanner scanInteger:NULL] && [scanner isAtEnd];
    if (isNumeric && ![otpString isEqualToString:@""] && otpString.length==6) {
        return true;
    }
    return false;
    
}

+(BOOL) isValidateDOB:(NSString *) dateOfBirth
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterShortStyle];
    [format setDateFormat:@"MM/dd/yy"];
    NSDate *validateDOB = [format dateFromString:dateOfBirth];
    if (validateDOB != nil)
        return YES;
    else
        return NO;
}

+ (BOOL)verifyPassword:(NSString *)password matchesConfirmationPassword:(NSString *)confirmPassword
{
    //
    // Caller is responsible for passing the a *pair* of strings.
    // I.e. passing the same object in both params will return YES but won't verify much!
    //
    
    if (![password isEqualToString:confirmPassword]) {
        
        return NO;
    }
    return YES;
}

+ (NSString*) checkingForNULL:(id)givenString
{
    if ([givenString isKindOfClass:[NSNull class]]) {
        return @"";
    }else if (givenString == nil){
        return @"";
    }
    else {
        return givenString;
    }
}

#pragma mark ==========NETWORK ALERT=================


+ (NSString*) getStringWithTrimSpaces:(NSString*)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSString*)giveImageNameWithURL:(NSString *)url{
    // Save image to disk with URL-based fileName
    NSString *filename = [NSString stringWithFormat:@"%@", url];
    filename = [filename stringByReplacingOccurrencesOfString:@"://" withString:@""];
    filename = [filename stringByReplacingOccurrencesOfString:@"/" withString:@""];
    //    filename = [filename stringByReplacingOccurrencesOfString:@"." withString:@""];
    return filename;
}

+ (NSString *)getStringFromDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:format];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+(void)saveTocart:(NSString *)name quantity:(NSInteger )quantity{
    
    [[NSUserDefaults standardUserDefaults]setObject: [NSString stringWithFormat:@"%ld",quantity] forKey:[NSString stringWithFormat:@"%@", name]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getQuantityforId:(NSString *)savedId {
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey: savedId] != nil) {
        return [[NSUserDefaults standardUserDefaults] valueForKey: savedId];
    }
    return @"0";
    
}

+ (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

@end
