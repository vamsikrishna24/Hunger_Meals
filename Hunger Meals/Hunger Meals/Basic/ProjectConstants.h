//
//  ProjectConstants.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 7/15/16.
//
#import "AppDelegate.h"
#import "BTAlertController.h"
#import "Utility.h"

#ifndef Constants_h
#define Constants_h

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

#define IS_IOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IPHONE_4s ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )

#define iPhone4 DEVICEFRAME.size.height<500
#define iPhone5 DEVICEFRAME.size.height>500
#define IS_IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define IS_NOT_IPAD UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad

#define APPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define APP_VERSION @"app_version"
#define KEYBOARD_HEIGHT 150.0

#define DEVICEOSVERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define DEVICEFRAME [[UIScreen mainScreen] bounds]
#define DEVICE_TOKEN @"USER_DEVICE_TOKEN"

#define INFO @"info"
#define OK @"OK"

#define FOLLOWING @"Following"
#define FOLLOWERS @"Followers"

#define STRING_PLEASE_WAIT @"Please wait..."


#define NOTIFICATION_NEWCOMMENT @"newComment"

#pragma mark -
#pragma mark - /< *** ALERT MESSAGES*** >/

#define USERDEFAULTS [NSUserDefaults standardUserDefaults]
#define FILEMANAGER [NSFileManager defaultManager]


#pragma mark-- Twitter Share

#define TwitterCallBack @"TwitterApp://twitter_access_tokens/"
#define TwitterAuthConsumerKeyValue @"TwitterAuthConsumerKey"
#define TwitterAuthConsumerSecretValue @"TwitterAuthConsumerSecret"

//Error and alert messages

//Network
#define STREAM_NETWORK_LOST @"No internet connection! Enable internet and pull down to refresh"

#define NETWORK_LOST @"No internet connection! Enable internet and try again"

#define NETWORK_CONNECTION_LOST_TAP_HERE_RETRY NETWORK_LOST

#define NETWORK_TIMEOUT_HEAVY_TRAFFIC @"We are experiencing heavy traffic. Please retry after sometime"

#define NETWORK_ERROR_UNKNOWN NETWORK_LOST

//Sign in and Registration

#define ALERT_FACEBOOK_NOT_LOGEDIN @"Requires login to your Facebook account from settings"

#define MSG_CONNECTING_TO_FACEBOOK @"Connecting to Facebook..."
#define MSG_CONNECTING_TO_GPLUS @"Connecting to Google+..."
#define MSG_PLEASE_WAIT_FOR_MOMENT @"Please wait for a moment..."

#define ALERT_SIGNIN_ERROR @"There was a problem signing in! Please try again"

#define ALERT_REGISTRATION_FAILED @"Registration Failed!"

#define PLEASE_WAIT @"Please wait...";

#define STATUSBAR_HEIGHT 20

#define CELL_TEXT_HEIGHT_DEFAULT 60

//Alert Messages

#define ALERT_PASSWORD_VALIDATION @"Password should contain one upper case letter, one number and minimum of 6-15 characters"
#define ALERT_CURRENT_PASSWORD_VALIDATION @"Passwords do not match"

#define ALERT_VALID_EMAIL @"Please enter a valid Email Address"
#define ALERT_EMAIL_VALIDATION @"Invalid login credentials"
#define ALERT_EMAILANDPASSWORD_EMPTY @"Email and Password cannot be blank. Please enter the credentials"
#define ALERT_FORGOTPASSWORD_VALIDATION @"ForgotPassword credentials not recognized"
#define ALERT_EMAIL_EMPTY2 @"Email Address Can't Be Empty"
#define ALERT_EMAIL_EMPTY @"Email Address cannot be left blank, Please enter a valid email address"
#define ALERT_PASSWORD_EMPTY @"Password cannot be left blank, Please enter a valid password"

#define ALERT_RESETPASWORD_MESSGAE @"Your Password has been reset successfully and is mailed to your registered email."

#define ALERT_PASSWORDVERFICATION @"Both password and confirm password should be same"
#define ALERT_PHONENUMBER_VALIDATION @"Please enter a valid mobile number"
#define ALERT_HEIGHT_VALIDATION @"Please enter a valid height"
#define ALERT_WEIGHT_VALIDATION @"Please enter a valid weight"
#define ALERT_AGE_VALIDATION @"Please enter a valid age"
#define ALERT_HEIGHT_LIMIT_VALIDATION @"Height should not exceed more than 3 digits"
#define ALERT_WEIGHT_LIMIT_VALIDATION @"Weight should not exceed more than 3 digits"
#define ALERT_AGE_LIMIT_VALIDATION @"Age should not exceed more than 2 digits"
#define ALERT_MATCHINGPASSWORDS @"Both Current Password and New Password should not be same"
#define ALERT_ENTERCREDENTIALS @"Please enter all the fields"
#define ALERT_ENTER_NEWPASSWORD_REPEATNEWPASSWORD @"New password and Repeat New password should not be empty"
#define ALERT_REPEATNEWPASSWORD @"Repeat New password should not be empty"
#define ALERT_NEWPASSWORD @"New password should not be empty"
#define ALERT_CURRENTPASSWORD @"Current password should not be empty"
#define ALERT_CURRENTPASSWORD_NEWPASSWORD @"Current password and New password should not be empty"
#define ALERT_CURRENTPASSWORD_REPEATPASSWORD @"Current password and Repeat New password should not be empty"


#define ALERT_USERNAME_VALIDATION @"Please enter username"
#define PROJECT_ALERT_TITLE @"Hunger Meals"

#define TOPBAR_COLOR [UIColor colorWithRed:171.0/255.0 green:171.0/255.0 blue:181.0/255.0 alpha:1]

#define APPLICATION_COLOR [UIColor colorWithRed:241/255.0f green:90/255.0f blue:36/255.0f alpha:1]

#define APPLICATION_TITLE_COLOR [UIColor colorWithRed:85.0/255.0f green:85.0/255.0f blue:85.0/255.0f alpha:1]

#define APPLICATION_SUBTITLE_COLOR [UIColor colorWithRed:119.0/255.0f green:119.0/255.0f blue:119.0/255.0f alpha:1]

#define UNKNOWN_USER_NAME @"User Name"
#define CURRENT_PASSWORD @"Current_Password"
#define CURRENT_EMAILID @"emailID"
#define CURRENT_PROFILE_ID @"Profile_ID"
#define CURRENT_PROFILE_NAME @"Profile_Name"
#define CURRENT_PROFILE_LOCATION @"Profile_Location"
#define SESSION_ID @"Session_ID"
#define CURRENT_PROFILE @"Current_Profile"
#define CURRENT_PROFILE_PICTURE_PATH_KEY @"LoggedIn_User_profile_picture"

#define TEMPLATE_FILENAME_FRAME @"FILEFRAMES"
#define TEMPLATE_FILENAME_CUES @"FILECUES"
#define TEMPLATE_FILENAME_STICKERS @"STICKERS"
#define TEMPLATE_FILENAME_POLLS @"FILEPOLLS"


#define DOCUMENT_DIRECTORY_PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]


#define PATH_TEMPLATES_IMAGES(filename_templates,url) [NSString stringWithFormat:@"%@/%@/%@",DOCUMENT_DIRECTORY_PATH,filename_templates,url]

#define TEMPLATES_IMAGES_PATH(filename_templates) [NSString stringWithFormat:@"%@/%@",DOCUMENT_DIRECTORY_PATH,filename_templates]


#define TEMPLATES_IMAGES_PATH_FRAME [NSString stringWithFormat:@"%@/%@",DOCUMENT_DIRECTORY_PATH,TEMPLATE_FILENAME_FRAME]

#define PROFILE_IMGS_PATH  [NSString stringWithFormat:@"%@/ProfileImages",DOCUMENT_DIRECTORY_PATH]
#define PROFILE_IMAGE_PATH(profile_url) [NSString stringWithFormat:@"%@/%@",PROFILE_IMGS_PATH,[Utility giveImageNameWithURL:profile_url]]


#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

#endif /* Constants_h */

