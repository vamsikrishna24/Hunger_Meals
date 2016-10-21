//
//  Utility.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 7/15/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (NSString *) getGenericeEmail:(NSString *)emailText;
+ (BOOL) isEmptywithspaces:(NSString*)str;
+ (BOOL) isValidatePassword:(NSString *) password;
+ (BOOL) isValidateEmail:(NSString *) emailString;
+(BOOL) isValidateDOB:(NSString *) dateOfBirth;
+(BOOL)isUserNameValidation:(NSString*)userName;
+ (BOOL) isValidateOTP:(NSString *) otpString;
+ (BOOL)verifyPassword:(NSString *)password matchesConfirmationPassword:(NSString *)confirmPassword;
+ (NSString*) checkingForNULL:(id)givenString;
+ (BOOL)isConnectionAvailableWithAlert:(BOOL)showAlert withClass:(id)currentClass;
+ (NSString*) getStringWithTrimSpaces:(NSString*)string;
+ (NSString*)giveImageNameWithURL:(NSString *)url;
+ (NSString*)getStringFromDate:(NSDate*)date withFormat:(NSString *)format;
+(void)saveTocart:(NSString *)name quantity:(NSInteger)quantity;
+ (NSString *)getQuantityforId:(NSString *)savedId;

@end
