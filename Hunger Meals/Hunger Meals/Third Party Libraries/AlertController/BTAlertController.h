//
//  BTAlertController.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 7/15/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^BTAlertCancelBlock)(void);
typedef void(^BTAlertOKBlock)(NSString* userName);
typedef void(^BTAlertOtherButtonsBlock)(NSInteger buttonIndex);

@interface BTAlertController : NSObject


+(void)showAlertWithEmailText:(NSString*)message withPlaceHolder:(NSString*)str andTitle:(NSString*)title andOkButtonTitle:(NSString*)okButtonTitle andtarget:(id)currentClass asText:(BOOL)isText andAlertCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOkBlock:(BTAlertOKBlock)okAction;

+(void)showAlertWithMessage:(NSString*)message andTitle:(NSString*)title andOkButtonTitle:(NSString*)okButtonTitle andCancelTitle:(NSString*)cancleTitle andtarget:(id)currentClass andAlertCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOkBlock:(BTAlertOKBlock)okAction;

+(void)showActionSheetForTitle1:(NSString*)title1 Title2:(NSString*)title2 Title3:(NSString*)title3 Title4:(NSString*)title4 Title5:(NSString*)title5 target:(id)currentClass withCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOKBlock:(BTAlertOtherButtonsBlock)okBlock;


+(void)showActionSheetForTitle1:(NSString*)title1 Title2:(NSString*)title2 Title3:(NSString*)title3 Title4:(NSString*)title4 target:(id)currentClass withCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOKBlock:(BTAlertOtherButtonsBlock)okBlock;

+(void)showActionSheetForTitle1:(NSString*)title1 Title2:(NSString*)title2 Title3:(NSString*)title3 target:(id)currentClass withCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOKBlock:(BTAlertOtherButtonsBlock)okBlock;

+(void)showActionSheetForTitle1:(NSString*)title1 Title2:(NSString*)title2 target:(id)currentClass withCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOKBlock:(BTAlertOtherButtonsBlock)okBlock;

+(void)showAlertForSignout:(NSString*)message andTitle:(NSString*)title andUploadButtonTitle:(NSString*)uplaodTitle andSignoutButtonTitle:(NSString*)signoutTitle andCancelButtonTitle:(NSString*)cancelTitle    andtarget:(id)currentClass andAlertCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOkBlock:(BTAlertOtherButtonsBlock)okAction;
+(void)showActionSheetForTitle1:(NSString*)title1 Title2:(NSString*)title2 Title3:(NSString*)title3 Title4:(NSString*)title4 Title5:(NSString*)title5 Title6:(NSString*)title6 target:(id)currentClass withCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOKBlock:(BTAlertOtherButtonsBlock)okBlock;

@end
