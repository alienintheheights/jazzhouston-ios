//
//  User.m
//  SocialApp
//
//  Created by Andrew Lienhard on 3/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "RoundedUIImage.h"



@implementation User


@synthesize userData = _userData;
@synthesize imageURLPath = _imageURLPath;
@synthesize imageFullURLPath = _imageFullURLPath;
@synthesize userId = _userId;
@synthesize imageData = _imageData;

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize fullName = _fullName;
@synthesize email = _email;
@synthesize url = _url;
@synthesize username = _username;
@synthesize cellPhone = _cellPhone;
@synthesize homePhone = _homePhone;


/**
Convenience function for fullName
 **/
-(NSString *) fullName
{

	return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
	
}

/**
 Parses the imageURLPath from the JSON object.
 **/
-(NSString *)imageURLPath
{
	if (!self.userData) return nil;
	
	if (!_imageURLPath) 
	{
		NSString *userAvatarImagePath = self.imageFullURLPath;
		if (userAvatarImagePath != (id)[NSNull null]) 
		{
			NSString *imageFileName = [userAvatarImagePath lastPathComponent];
			NSArray *anArray = [NSArray arrayWithObjects:JH_USER_AVATAR_URL, [NSString stringWithFormat:@"%d", self.userId], JH_USER_AVATAR_URL_SUBPATH, imageFileName, nil];
			NSString *imagePath = [anArray componentsJoinedByString:@""];
		    _imageURLPath = imagePath;
		}
	}
	return _imageURLPath;
	
}

@end
