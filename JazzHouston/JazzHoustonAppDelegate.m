//
//  SocialAppAppDelegate.m
//  SocialApp
//
//  Created by Andrew Lienhard on 3/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "JazzHoustonAppDelegate.h"
#import "WelcomeViewController.h"


@implementation JazzHoustonAppDelegate

NSString * const HOSTNAME = @"jazzhouston.com";

@synthesize window = _window;

static BOOL _isReady = NO;

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// TODO: THIS IS HACKED BS. I WILL FIX
	
	// auto-login
	if (!_isReady) {
		[ApplicationDelegate.jazzHoustonEngine checkSession:^(NSString* userId) {
				if (!userId ) {
						UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
						WelcomeViewController *startupVC = [storyboard instantiateViewControllerWithIdentifier:@"WelcomeController"];
						[self.window.rootViewController presentViewController:startupVC animated:NO  completion:nil];
				} else {
					// do something with the user id
					_isReady = YES;
				}
			}
			errorHandler:^(NSError* error) {
				NSLog(@"Error: %@", [error localizedDescription]);
				[[[UIAlertView alloc] initWithTitle:@"Error Checking Session"
											message:@"Please try again later."
										   delegate:nil
								  cancelButtonTitle:@"OK"
								  otherButtonTitles:nil] show];
			}];
	}
	
	
	
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// TODO: Temp code, to replace
	self.jazzHoustonEngine = [[JazzHoustonEngine alloc] initWithHostName:HOSTNAME];
	[self.jazzHoustonEngine useCache];
	// using categorized UIImageView from MKNetworkKit
	[UIImageView setDefaultEngine:self.jazzHoustonEngine];
	
	
	
	return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
