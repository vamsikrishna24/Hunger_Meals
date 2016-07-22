//
//  MTGenericAlertView.h
//  MTGenericAlertView
//
//  Created by SivajeeBattina on 8/12/15.
//  Copyright (c) 2015 Paradigmcreatives. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTGenericAlertViewDelegate

- (void)alertView:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface MTGenericAlertView : UIView<MTGenericAlertViewDelegate>

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *customInputView;
@property (nonatomic, strong) NSArray *customButtonTitlesArray;
@property (nonatomic, strong) NSArray *customButtonsArray;
@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UIButton *popUpCloseButton;
@property (nonatomic ,assign) BOOL isPopUpView;
@property (nonatomic, assign) id<MTGenericAlertViewDelegate> delegate;

@property (copy) void (^AlertViewButtonActionCompletionHandler)(MTGenericAlertView *alertView, int buttonIndex) ;

- (id)init;

- (id)initWithTitle:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)font backgroundImage:(UIImage *)image;

- (void)show;

- (void)close;

- (void)setAlertViewButtonActionCompletionHandler:(void (^)(MTGenericAlertView *alertView, int buttonIndex))onButtonTouchUpInside;

@end
