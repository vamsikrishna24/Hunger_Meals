//
//  MTGenericAlertView.m
//  MTGenericAlertView
//
//  Created by SivajeeBattina on 8/12/15.
//  Copyright (c) 2015 Paradigmcreatives. All rights reserved.
//

#import "MTGenericAlertView.h"
#import <QuartzCore/QuartzCore.h>

const static CGFloat kAlertViewDefaultButtonHeight       = 40;
const static CGFloat kAlertViewDefaultButtonSpacerHeight = 1;
const static CGFloat kAlertViewCornerRadius              = 7;

@implementation MTGenericAlertView

CGFloat buttonHeight = 0;
CGFloat buttonSpacerHeight = 0;
CGFloat alertTitleLabelHeight = 44;

/***********************************************/
#pragma -mark initialization Methods
/***********************************************/

- (id)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        self.delegate = self;
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)font backgroundImage:(UIImage *)image {
    self = [self init];
    
    self.alertTitleLabel = [[UILabel alloc] init];
    self.alertTitleLabel.text = title;
    self.alertTitleLabel.textAlignment = NSTextAlignmentCenter;
    if (color) {
        self.alertTitleLabel.textColor = color;
    }
    if (font) {
        self.alertTitleLabel.font = font;
    }
    if (image) {
        self.alertTitleLabel.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    
    return self;
}

/***********************************************/
#pragma -mark Custom Methods
/***********************************************/

- (void)show {
    self.containerView = [self createContainerView];
    self.containerView.clipsToBounds = YES;
    self.containerView.layer.shouldRasterize = YES;
    self.containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self addSubview:self.containerView];
    
    // On iOS7, calculate with orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        switch (interfaceOrientation) {
            case UIInterfaceOrientationLandscapeLeft:
                self.transform = CGAffineTransformMakeRotation(M_PI * 270.0 / 180.0);
                break;
                
            case UIInterfaceOrientationLandscapeRight:
                self.transform = CGAffineTransformMakeRotation(M_PI * 90.0 / 180.0);
                break;
                
            case UIInterfaceOrientationPortraitUpsideDown:
                self.transform = CGAffineTransformMakeRotation(M_PI * 180.0 / 180.0);
                break;
                
            default:
                break;
        }
        
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        // On iOS8, just place the dialog in the middle
    } else {
        CGSize screenSize = [self getScreenSize];
        CGSize containerSize = [self getContainerSize];
        CGSize keyboardSize = CGSizeMake(0, 0);
        
        self.containerView.frame = CGRectMake((screenSize.width - containerSize.width) / 2, (screenSize.height - keyboardSize.height - containerSize.height) / 2, containerSize.width, containerSize.height);
    }
    
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
    //Remove the presenting animation for popup
    CGFloat animationDuration = 0.2f;
    if (_isPopUpView) {
        animationDuration = 0.0f;
        [self addPopUpCloseButton:self.containerView];
    }
    
    self.containerView.layer.opacity = 0.5f;
    self.containerView.layer.transform = CATransform3DMakeScale(1.3f, 1.3f, 1.0);
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
                         self.containerView.layer.opacity = 1.0f;
                         self.containerView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
    
}

- (void)setSubView: (UIView *)subView {
    self.containerView = subView;
}

// Creates the container view here: create the container, then add the custom content and buttons
- (UIView *)createContainerView {
    if (self.customInputView == NULL) {
        self.customInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 150)];
    }
    
    CGSize screenSize = [self getScreenSize];
    CGSize containerSize = [self getContainerSize];
    
    // For the black background
    self.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    if (self.alertTitleLabel) {
        self.alertTitleLabel.frame = CGRectMake(0, 0, containerSize.width, alertTitleLabelHeight);
        
        CGRect contentFrame = self.customInputView.frame;
        contentFrame.origin.y += CGRectGetHeight(self.alertTitleLabel.frame);
        self.customInputView.frame = contentFrame;
    }
    
    // This is the container; we attach the custom content and the buttons to this one
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - containerSize.width) / 2, (screenSize.height - containerSize.height) / 2, containerSize.width, containerSize.height)];
    
    // First, we style the dialog to match the iOS7 UIAlertView >>>
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = container.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:233.0/255.0 green:233.0/255.0 blue:233.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1.0f] CGColor],
                       nil];
    CGFloat cornerRadius = kAlertViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    [container.layer insertSublayer:gradient atIndex:0];
    container.layer.cornerRadius = cornerRadius;
    container.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
    container.layer.borderWidth = 1;
    container.layer.shadowRadius = cornerRadius + 5;
    container.layer.shadowOpacity = 0.1f;
    container.layer.shadowOffset = CGSizeMake(0 - (cornerRadius+5)/2, 0 - (cornerRadius+5)/2);
    container.layer.shadowColor = [UIColor blackColor].CGColor;
    container.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:container.bounds cornerRadius:container.layer.cornerRadius].CGPath;
    
    // Add the custom container if there is any
    if (self.alertTitleLabel) {
        [container addSubview:self.alertTitleLabel];
    }
    
    [container addSubview:self.customInputView];
    
    if (self.isPopUpView) {
        
    }
    else {
        // There is a line above the button
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, container.bounds.size.height - buttonHeight - buttonSpacerHeight, container.bounds.size.width, buttonSpacerHeight)];
        lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
        [container addSubview:lineView];
        [self addButtonsToView:container];
    }
    
    return container;
}

// Helper function: add buttons to container
- (void)addButtonsToView: (UIView *)container {
    if (self.customButtonTitlesArray==NULL && self.customButtonsArray == NULL) {
        return;
    }
    
    if (self.customButtonTitlesArray.count>0) {
        CGFloat buttonWidth = container.bounds.size.width / [self.customButtonTitlesArray count];
        
        for (int i=0; i<[self.customButtonTitlesArray count]; i++) {
            UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            closeButton.frame = CGRectMake(i * buttonWidth , container.bounds.size.height - buttonHeight, buttonWidth, buttonHeight);
            [closeButton addTarget:self action:@selector(alertViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            closeButton.tag = i;
            [closeButton setTitle:[self.customButtonTitlesArray objectAtIndex:i] forState:UIControlStateNormal];
            [closeButton setTitleColor:[UIColor colorWithRed:0.0f green:0.5f blue:1.0f alpha:1.0f] forState:UIControlStateNormal];
            [closeButton setTitleColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.5f] forState:UIControlStateHighlighted];
            closeButton.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
            closeButton.layer.cornerRadius = kAlertViewCornerRadius;
            [container addSubview:closeButton];
            
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(i * buttonWidth, container.bounds.size.height - buttonHeight, buttonSpacerHeight, buttonHeight)];
            lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
            [container addSubview:lineView];
        }
    }
    else if(self.customButtonsArray.count>0) {
        CGFloat buttonWidth = container.bounds.size.width / [self.customButtonsArray count];
        
        for (int i=0; i<[self.customButtonsArray count]; i++) {
            UIButton *closeButton = [self.customButtonsArray objectAtIndex:i];
            closeButton.frame = CGRectMake(i * buttonWidth , container.bounds.size.height - buttonHeight, buttonWidth, buttonHeight);
            [closeButton addTarget:self action:@selector(alertViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            closeButton.tag = i;
            [container addSubview:closeButton];
            
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(i * buttonWidth, container.bounds.size.height - buttonHeight, buttonSpacerHeight, buttonHeight)];
            lineView.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
            [container addSubview:lineView];
        }
    }
}

// Helper function: calculate and return the container's size
- (CGSize)getContainerSize {
    if (self.customButtonsArray.count > 0 || self.customButtonTitlesArray.count>0) {
        buttonHeight       = kAlertViewDefaultButtonHeight;
        buttonSpacerHeight = kAlertViewDefaultButtonSpacerHeight;
    }
    
    CGFloat customInputViewWidth = CGRectGetWidth(self.customInputView.frame);
    CGFloat customInputViewHeight;
    
    if (self.isPopUpView) {
        customInputViewHeight = CGRectGetHeight(self.customInputView.frame);
    }
    else {
        if (self.alertTitleLabel.text.length<=0) {
            customInputViewHeight = CGRectGetHeight(self.customInputView.frame) + buttonHeight + buttonSpacerHeight;
        }else {
            customInputViewHeight = CGRectGetHeight(self.customInputView.frame) + buttonHeight + buttonSpacerHeight + alertTitleLabelHeight;
        }
    }
    
    return CGSizeMake(customInputViewWidth, customInputViewHeight);
}

// Helper function: calculate and return the screen's size
- (CGSize)getScreenSize {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    // On iOS7, screen width and height doesn't automatically follow orientation
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
            CGFloat tmp = screenWidth;
            screenWidth = screenHeight;
            screenHeight = tmp;
        }
    }
    
    return CGSizeMake(screenWidth, screenHeight);
}

- (void)addPopUpCloseButton: (UIView *)container {
    CGSize containerSize = [self getContainerSize];
    if (!_popUpCloseButton) {
        
    _popUpCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _popUpCloseButton.frame= CGRectMake(container.frame.origin.x+containerSize.width-15,container.frame.origin.y-15, 30, 30);
    [_popUpCloseButton addTarget:self action:@selector(removePopUp) forControlEvents:UIControlEventTouchUpInside];
    [_popUpCloseButton setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    
    }else {
         _popUpCloseButton.frame= CGRectMake(container.frame.origin.x+containerSize.width-_popUpCloseButton.frame.size.height/2,container.frame.origin.y-_popUpCloseButton.frame.size.height/2, _popUpCloseButton.frame.size.width, _popUpCloseButton.frame.size.height);
        [_popUpCloseButton addTarget:self action:@selector(removePopUp) forControlEvents:UIControlEventTouchUpInside];
    }
    [self addSubview:_popUpCloseButton];
}

- (void) removePopUp {
    [self close];
}

- (void) setPopUpFrame{
    CGSize containerSize = [self getContainerSize];

     self.popUpCloseButton.frame= CGRectMake(_containerView.frame.origin.x+containerSize.width-18,_containerView.frame.origin.y-15, _popUpCloseButton.frame.size.width, _popUpCloseButton.frame.size.width);
}
/***********************************************/
#pragma -mark IBAction Methods
/***********************************************/
- (IBAction)alertViewButtonClicked:(id)sender {

    if (self.delegate != NULL) {
        [self.delegate alertView:self clickedButtonAtIndex:[sender tag]];
    }
    
    if (self.AlertViewButtonActionCompletionHandler != NULL) {
        self.AlertViewButtonActionCompletionHandler(self, (int)[sender tag]);
    }
}

// Default button behaviour
- (void)alertView:(MTGenericAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Button Clicked! %d, %d", (int)buttonIndex, (int)[alertView tag]);
    [self close];
}

// Dialog close animation then cleaning and removing the view from the parent
- (void)close {
    CATransform3D currentTransform = self.containerView.layer.transform;
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat startRotation = [[self.containerView valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
        CATransform3D rotation = CATransform3DMakeRotation(-startRotation + M_PI * 270.0 / 180.0, 0.0f, 0.0f, 0.0f);
        
        self.containerView.layer.transform = CATransform3DConcat(rotation, CATransform3DMakeScale(1, 1, 1));
    }
    
    self.containerView.layer.opacity = 1.0f;
    
    //Remove the closing animation for popup
    CGFloat animationDuration = 0.2f;
    if (_isPopUpView) {
        animationDuration = 0.0f;
    }
    
    [UIView animateWithDuration:animationDuration delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.containerView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
                         self.containerView.layer.opacity = 0.0f;
                     }
                     completion:^(BOOL finished) {
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}

/***********************************************/
#pragma -mark KeyBoard Methods
/***********************************************/

// Handle keyboard show/hide changes
- (void)keyboardWillShow: (NSNotification *)notification {
    CGSize screenSize = [self getScreenSize];
    CGSize containerSize = [self getContainerSize];
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation) && NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1) {
        CGFloat tmp = keyboardSize.height;
        keyboardSize.height = keyboardSize.width;
        keyboardSize.width = tmp;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.containerView.frame = CGRectMake((screenSize.width - containerSize.width) / 2, (screenSize.height - keyboardSize.height - containerSize.height) / 2, containerSize.width, containerSize.height);
                         
                          [self setPopUpFrame];
                         
                     }
                     completion:nil
     ];
}

- (void)keyboardWillHide: (NSNotification *)notification {
    CGSize screenSize = [self getScreenSize];
    CGSize containerSize = [self getContainerSize];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.containerView.frame = CGRectMake((screenSize.width - containerSize.width) / 2, (screenSize.height - containerSize.height) / 2, containerSize.width, containerSize.height);
                         
                         [self setPopUpFrame];
                     }
                     completion:nil
     ];
}

/***********************************************/
#pragma -mark Device Orientation Methods
/***********************************************/

// Alert View Rotation changed, on iOS7 according to device orientation
- (void)changeOrientationForIOS7 {
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGFloat startRotation = [[self valueForKeyPath:@"layer.transform.rotation.z"] floatValue];
    CGAffineTransform rotation;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 270.0 / 180.0);
            break;
            
        case UIInterfaceOrientationLandscapeRight:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 90.0 / 180.0);
            break;
            
        case UIInterfaceOrientationPortraitUpsideDown:
            rotation = CGAffineTransformMakeRotation(-startRotation + M_PI * 180.0 / 180.0);
            break;
            
        default:
            rotation = CGAffineTransformMakeRotation(-startRotation + 0.0);
            break;
    }
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.containerView.transform = rotation;
                         
                     }
                     completion:nil
     ];
}

// Alert View Rotation changed, on iOS8 according to device orientation
- (void)changeOrientationForIOS8: (NSNotification *)notification {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.0f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         CGSize containerSize = [self getContainerSize];
                         CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
                         self.frame = CGRectMake(0, 0, screenWidth, screenHeight);
                         self.containerView.frame = CGRectMake((screenWidth - containerSize.width) / 2, (screenHeight - keyboardSize.height - containerSize.height) / 2, containerSize.width, containerSize.height);
                         [self setPopUpFrame];
                     }
                     completion:nil
     ];
}

// Handle device orientation changes
- (void)deviceOrientationDidChange: (NSNotification *)notification {
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [self changeOrientationForIOS7];
    } else {
        [self changeOrientationForIOS8:notification];
    }
}

/***********************************************/
#pragma -mark Deallocate Method
/***********************************************/

- (void)dealloc {
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
