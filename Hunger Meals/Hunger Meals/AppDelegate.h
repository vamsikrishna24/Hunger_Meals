//
//  AppDelegate.h
//  Hunger Meals
//
//  Created by Vamsi T on 08/07/2016.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/SignIn.h>
#import <CoreData/CoreData.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LandingPageViewController.h"
#import "HMLandingViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) UINavigationController *homeNavigationController;
@property (assign, nonatomic) NSInteger cartItemsValue;


@property int selectedInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) showInitialScreen;

@property (nonatomic, strong) CLLocationManager *locationManager;

-(void) enableCurrentLocation;


@end

