//
//  CheckConnection.m
//
//  Created by SivajeeBattina on 7/15/16.
//

#import "CheckConnection.h"
#import "BTAlertController.h"
#import "ProjectConstants.h"

@class Reachability;
@implementation CheckConnection

- (BOOL) checkInternetRechable
{
	internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
	
	
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    BOOL connectionRequired= [internetReach connectionRequired];
    NSString* statusString= @"";
	
	

    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = @"Access Not Available";
			isInternetAvailable=FALSE;
            break;
        }
            
        case ReachableViaWWAN:
        {
			isInternetAvailable=TRUE;
            statusString = @"Reachable WWAN";
            break;
        }
        case ReachableViaWiFi:
        {
			isInternetAvailable=TRUE;
			statusString= @"Reachable WiFi";
            break;
		}
    }
    if(connectionRequired)
    {
        //statusString= [NSString stringWithFormat: @"%@, Connection Required", statusString];
		isInternetAvailable=FALSE;
    }
	return isInternetAvailable;
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self checkInternetRechable];
}

- (BOOL) connectedToNetwork
{
	// Create zero addy
	struct sockaddr_in zeroAddress;
	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;
	
	// Recover reachability flags
	SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
	SCNetworkReachabilityFlags flags;
	
	BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	CFRelease(defaultRouteReachability);
	
	if (!didRetrieveFlags)
	{
		return NO;
	}
	
	BOOL isReachable = flags & kSCNetworkFlagsReachable;
	BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
	return (isReachable && !needsConnection) ? YES : NO;
}


//call like:
-(void) startWithCurrentClass:(id)currentClass {
	if (![self connectedToNetwork]) {
        [BTAlertController showAlertWithMessage:@"This action could not be completed. Please check your network connection." andTitle:@"" andOkButtonTitle:nil andCancelTitle:@"Ok" andtarget:currentClass andAlertCancelBlock:^{
            
        } andAlertOkBlock:^(NSString *userName) {
            
        }];
        
        
	} else {
		//do something 
	}
}



@end
