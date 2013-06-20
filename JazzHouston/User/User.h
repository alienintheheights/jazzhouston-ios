//
//  User.h
//  SocialApp
//
//  Created by Andrew Lienhard on 3/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject



#define JH_USER_AVATAR_URL @"/user/image/"
#define JH_USER_AVATAR_URL_SUBPATH @"/avatar/"
#define DEFAULT_IMAGE [UIImage imageNamed:@"forum-icon-blue.png"]


@property (nonatomic, strong) NSDictionary *userData;
@property (nonatomic, strong) NSString *imageURLPath;
@property (nonatomic, strong) NSString *imageFullURLPath;
@property (nonatomic) int userId;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) UIImage *imageData;

@end
