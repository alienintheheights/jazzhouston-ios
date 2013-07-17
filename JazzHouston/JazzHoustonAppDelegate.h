//
//  SocialAppAppDelegate.h
//  SocialApp
//
//  Created by Andrew Lienhard on 3/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JazzHoustonEngine.h"

@interface JazzHoustonAppDelegate : UIResponder <UIApplicationDelegate>


#define ApplicationDelegate ((JazzHoustonAppDelegate *)[UIApplication sharedApplication].delegate)
extern NSString * const HOSTNAME ;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JazzHoustonEngine *jazzHoustonEngine;

@end
