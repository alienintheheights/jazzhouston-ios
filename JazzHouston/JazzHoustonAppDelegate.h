//
//  SocialAppAppDelegate.h
//  SocialApp
//
//  Created by Andrew Lienhard on 3/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumEngine.h"

@interface JazzHoustonAppDelegate : UIResponder <UIApplicationDelegate>


#define ApplicationDelegate ((JazzHoustonAppDelegate *)[UIApplication sharedApplication].delegate)


@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ForumEngine *forumEngine;

@end
