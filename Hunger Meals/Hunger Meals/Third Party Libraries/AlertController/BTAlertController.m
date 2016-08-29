//
//  BTAlertController.h
//  Hunger Meals
//
//  Created by SivajeeBattina on 7/15/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import "BTAlertController.h"
#import "AppDelegate.h"
#import "UIAlertView+CustomAlertView.h"
#import "UIActionSheet+Blocks.h"
#import "ProjectConstants.h"

static UIAlertController *presentedViewController; // static means it is only accessible from the current file
static UIAlertView *presentedAlertView;

static NSString *currenttext;

@interface BTAlertController(){
    
}

@property(nonatomic,strong)BTAlertCancelBlock cancelBlock;
@property(nonatomic,strong)BTAlertOKBlock okBlock;

@end

@implementation BTAlertController


+(void)showAlertWithEmailText:(NSString*)message withPlaceHolder:(NSString*)str andTitle:(NSString*)title andOkButtonTitle:(NSString*)okButtonTitle andtarget:(id)currentClass asText:(BOOL)isText andAlertCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOkBlock:(BTAlertOKBlock)okAction{
    if (IS_IOS8) {
        presentedViewController=   [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       UITextField *userName = presentedViewController.textFields.firstObject;
                                                       [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                                                       name:UITextFieldTextDidChangeNotification
                                                                                                     object:nil];
                                                       okAction(userName.text);
                                                   }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           cancelBlock();
                                                           [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                                                           name:UITextFieldTextDidChangeNotification
                                                                                                         object:nil];
                                                           [presentedViewController dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        [presentedViewController addAction:cancel];
        [presentedViewController addAction:ok];
        
        [currentClass presentViewController:presentedViewController animated:YES completion:nil];
        
        [presentedViewController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            if (isText)
                textField.text = str;
            else
                textField.placeholder = str;
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification
                                                       object:textField];
        }];
        
    }else{
        presentedAlertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:okButtonTitle, nil];
        presentedAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *textField = [presentedAlertView textFieldAtIndex:0];
        if (isText)
            textField.text = str;
         else
             textField.placeholder = str;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertViewTextFieldDidChange:) name:UITextFieldTextDidChangeNotification
                                                   object:textField];

        [presentedAlertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                name:UITextFieldTextDidChangeNotification
                                                              object:nil];

                cancelBlock();
            }else if (buttonIndex == 1){
                [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                name:UITextFieldTextDidChangeNotification
                                                              object:nil];

                okAction([alertView textFieldAtIndex:0].text);
                
            }
        }];
    }
}

+(void)showAlertWithMessage:(NSString*)message andTitle:(NSString*)title andOkButtonTitle:(NSString*)okButtonTitle andCancelTitle:(NSString*)cancleTitle andtarget:(id)currentClass andAlertCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOkBlock:(BTAlertOKBlock)okAction{
    if (IS_IOS8) {
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        alert.view.tintColor = [UIColor colorWithWhite:0 alpha:0.6];
        if (cancleTitle.length) {
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           cancelBlock();
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        [alert addAction:cancel];
        }
        
        if (okButtonTitle.length) {
            UIAlertAction* ok = [UIAlertAction actionWithTitle:okButtonTitle style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
//                                                           UITextField *userName = alert.textFields.firstObject;
                                                           okAction(@"OK");
                                                       }];
            [alert addAction:ok];
        }
        [currentClass presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancleTitle otherButtonTitles:okButtonTitle, nil];
        
        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
            
            if ([title isEqualToString:@"Yes"]) {
                okAction(@"OK");

            }else if ([title isEqualToString:@"OK"] || [title isEqualToString:@"Ok"]){
                okAction(@"OK");
            }
        }];
    }
}

+(void)showActionSheetForTitle1:(NSString*)title1 Title2:(NSString*)title2 target:(id)currentClass withCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOKBlock:(BTAlertOtherButtonsBlock)okBlock{
    if (IS_IOS8) {
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:title1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        okBlock(0);
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:title2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        okBlock(1);
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        [actionSheetController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [actionSheetController addAction:action1];
    [actionSheetController addAction:action2];
    [actionSheetController addAction:cancel];
    
//    actionSheetController.view.tintColor = BTBlackColor;
    [currentClass presentViewController:actionSheetController animated:YES completion:nil];
        
        
    }else {
      //For IOS 7 devices
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:title1,title2, nil];
        
        as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
            
             okBlock(buttonIndex);
            NSLog(@"Chose %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
        };
        
        UIViewController *vc =currentClass;
        [as showInView:[vc view]];
        
    }
}


+(void)showActionSheetForTitle1:(NSString*)title1 Title2:(NSString*)title2 Title3:(NSString*)title3 target:(id)currentClass withCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOKBlock:(BTAlertOtherButtonsBlock)okBlock{
    if (IS_IOS8) {

     UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     
     UIAlertAction *action1 = [UIAlertAction actionWithTitle:title1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
         okBlock(0);
     }];
     
     UIAlertAction *action2 = [UIAlertAction actionWithTitle:title2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
         okBlock(1);
     }];

    UIAlertAction *action3 = [UIAlertAction actionWithTitle:title3 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        okBlock(2);
    }];

     UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
     [actionSheetController dismissViewControllerAnimated:YES completion:nil];
     }];
     
     [actionSheetController addAction:action1];
     [actionSheetController addAction:action2];
     [actionSheetController addAction:action3];
     [actionSheetController addAction:cancel];
    
//     actionSheetController.view.tintColor = BTBlackColor;
     [currentClass presentViewController:actionSheetController animated:YES completion:nil];
}
    else
    {
        //For IOS 7 devices
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:title1,title2,title3, nil];
        
        as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
            
            okBlock(buttonIndex);
            NSLog(@"Chose %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
        };
        
        UIViewController *vc =currentClass;
        [as showInView:[vc view]];
        
    }
}
+(void)showActionSheetForTitle1:(NSString*)title1 Title2:(NSString*)title2 Title3:(NSString*)title3 Title4:(NSString*)title4 target:(id)currentClass withCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOKBlock:(BTAlertOtherButtonsBlock)okBlock{
    if (IS_IOS8) {
        
        UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:title1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(0);
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:title2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(1);
        }];
        
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:title3 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(2);
        }];
        
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:title4 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(3);
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [actionSheetController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [actionSheetController addAction:action1];
        [actionSheetController addAction:action2];
        [actionSheetController addAction:action3];
        [actionSheetController addAction:action4];
        [actionSheetController addAction:cancel];
        
        //     actionSheetController.view.tintColor = BTBlackColor;
        [currentClass presentViewController:actionSheetController animated:YES completion:nil];
    }
    else
    {
        //For IOS 7 devices
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:title1,title2,title3,title4, nil];
        
        as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
            
            okBlock(buttonIndex);
            NSLog(@"Chose %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
        };
        
        UIViewController *vc =currentClass;
        [as showInView:[vc view]];
        
    }
}


+(void)showActionSheetForTitle1:(NSString*)title1 Title2:(NSString*)title2 Title3:(NSString*)title3 Title4:(NSString*)title4 Title5:(NSString*)title5 target:(id)currentClass withCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOKBlock:(BTAlertOtherButtonsBlock)okBlock {
    if (IS_IOS8) {
        
        UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:title1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(0);
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:title2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(1);
        }];
        
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:title3 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(2);
        }];
        
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:title4 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(3);
        }];
        
        UIAlertAction *action5 = [UIAlertAction actionWithTitle:title5 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(4);
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [actionSheetController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [actionSheetController addAction:action1];
        [actionSheetController addAction:action2];
        [actionSheetController addAction:action3];
        [actionSheetController addAction:action4];
        [actionSheetController addAction:action5];
        [actionSheetController addAction:cancel];
        
        //     actionSheetController.view.tintColor = BTBlackColor;
        [currentClass presentViewController:actionSheetController animated:YES completion:nil];
    }
    else
    {
        //For IOS 7 devices
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:title1,title2,title3,title4,title5, nil];
        
        as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
            
            okBlock(buttonIndex);
            NSLog(@"Chose %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
        };
        UIViewController *vc =currentClass;
        [as showInView:[vc view]];
        
        
    }
}

+(void)showActionSheetForTitle1:(NSString*)title1 Title2:(NSString*)title2 Title3:(NSString*)title3 Title4:(NSString*)title4 Title5:(NSString*)title5 Title6:(NSString*)title6 target:(id)currentClass withCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOKBlock:(BTAlertOtherButtonsBlock)okBlock {
    if (IS_IOS8) {
        
        UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:title1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(0);
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:title2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(1);
        }];
        
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:title3 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(2);
        }];
        
        UIAlertAction *action4 = [UIAlertAction actionWithTitle:title4 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(3);
        }];
        
        UIAlertAction *action5 = [UIAlertAction actionWithTitle:title5 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(4);
        }];
        UIAlertAction *action6 = [UIAlertAction actionWithTitle:title6 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            okBlock(5);
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            [actionSheetController dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [actionSheetController addAction:action1];
        [actionSheetController addAction:action2];
        [actionSheetController addAction:action3];
        [actionSheetController addAction:action4];
        [actionSheetController addAction:action5];
        [actionSheetController addAction:action6];
        [actionSheetController addAction:cancel];
        
        //     actionSheetController.view.tintColor = BTBlackColor;
        [currentClass presentViewController:actionSheetController animated:YES completion:nil];
    }
    else
    {
        //For IOS 7 devices
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:title1,title2,title3,title4,title5,title6, nil];
        
        as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        as.tapBlock = ^(UIActionSheet *actionSheet, NSInteger buttonIndex){
            
            okBlock(buttonIndex);
            NSLog(@"Chose %@", [actionSheet buttonTitleAtIndex:buttonIndex]);
        };
        UIViewController *vc =currentClass;
        [as showInView:[vc view]];
        
        
    }
}

+(void)alertViewTextFieldDidChange:(NSNotification *)notification{
    /*
    UITextField *login = [presentedAlertView textFieldAtIndex:0];
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    NSString *filtered = [[login.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    NSString *trimmedString = [filtered stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([trimmedString isEqualToString:@""]) {
        login.text = @"";
        return;
    }
    if ([filtered length]>40) {
        login.text = currenttext;
        return;
    }
    
    login.text = filtered;
    currenttext = filtered;*/
}

    
//Observe the Notification When the text Field Changes
+(void)alertTextFieldDidChange:(NSNotification *)notification
{
    UIAlertController *alertController = (UIAlertController *)presentedViewController;
    if (alertController){
        /*
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
        NSString *filtered = [[login.text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        NSString *trimmedString = [filtered stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        okAction.enabled = trimmedString.length > 0;

        if ([trimmedString isEqualToString:@""]) {
            login.text = @"";
            return;
        }
        if ([filtered length]>40) {
            login.text = currenttext;
            return;
        }
        
        login.text = filtered;
        currenttext = filtered;*/
    }
}
//sign out alert
+(void)showAlertForSignout:(NSString*)message andTitle:(NSString*)title andUploadButtonTitle:(NSString*)uplaodTitle andSignoutButtonTitle:(NSString*)signoutTitle andCancelButtonTitle:(NSString*)cancelTitle    andtarget:(id)currentClass andAlertCancelBlock:(BTAlertCancelBlock)cancelBlock andAlertOkBlock:(BTAlertOtherButtonsBlock)okAction {
    if (IS_IOS8) {
        UIAlertController * alert=   [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//        alert.view.tintColor = BTOrangeColor;
        if(uplaodTitle.length)
        {
            UIAlertAction* upload = [UIAlertAction actionWithTitle:uplaodTitle style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action) {
                                                               
                                                               okAction(1);
                                                           }];
            [alert addAction:upload];
        }
        if (signoutTitle.length) {
            UIAlertAction* signout = [UIAlertAction actionWithTitle:signoutTitle style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                        
                                                           okAction(0);
                                                       }];
            [alert addAction:signout];
        }
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           cancelBlock();
                                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        [alert addAction:cancel];

                [currentClass presentViewController:alert animated:YES completion:nil];
    }
    
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:uplaodTitle,signoutTitle, nil];
        
        [alertView showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                cancelBlock();
            }else if (buttonIndex == 1){
                okAction(1);
            }
            else if (buttonIndex==2)
            {
                okAction(0);
            }
        }];
    }
}

@end
