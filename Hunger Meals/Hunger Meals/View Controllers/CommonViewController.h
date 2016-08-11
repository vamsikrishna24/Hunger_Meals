//
//  CommonViewController.h
//  SmartVijayawada
//
//  Created by SivajeeBattina on 12/14/15.
//  Copyright © 2015 Paradigmcreatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import "Constants.h"
#import "Fonts.h"
#import "SWRevealViewController.h"

typedef NS_ENUM(NSInteger, TabBarItem)
{
    ItemDiscover = 1,
    ItemNews,
    ItemServices,
};

@interface CommonViewController : UIViewController<MBProgressHUDDelegate>

- (void) showActivityIndicatorWithTitle: (NSString *) title;
- (void) hideActivityIndicator;

@end
