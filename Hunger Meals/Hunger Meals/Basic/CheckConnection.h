//
//  CheckConnection.h
//  SpotLife
//
//  Created by SivajeeBattina on 7/15/16.
//  Copyright © 2016 paradigm-creatives. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

#import <sys/types.h>
#import <sys/socket.h>
#import <netinet/in.h>

@interface CheckConnection : NSObject {
	Reachability* hostReach;
	Reachability* internetReach;
	Reachability* wifiReach;
	BOOL isInternetAvailable;
}
- (BOOL) checkInternetRechable;
- (void) startWithCurrentClass:(id)currentClass ;
- (BOOL) connectedToNetwork;

@end
