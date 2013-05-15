//
//  User.m
//  SocialApp
//
//  Created by Andrew Lienhard on 3/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@interface User()
@end

@implementation User

#define JH_USER_AVATAR_URL @"http://jazzhouston.com/user/image/"
#define JH_USER_AVATAR_URL_SUBPATH @"/avatar/"


@synthesize userData = _userData;
@synthesize imageURLPath = _imageURLPath;
@synthesize imageFullURLPath = _imageFullURLPath;
@synthesize userId = _userId;

@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize fullName = _fullName;
@synthesize email = _email;
@synthesize url = _url;
@synthesize username = _username;
@synthesize avatarData = _avatarData;


-(NSString *) fullName
{
	return [self.firstName stringByAppendingString:[@" " stringByAppendingString:self.lastName] ];
	
}

-(id)initWithJSONData:(NSDictionary *)userData
{
	self = [super init];
	if (self)
	{
		self.userData = userData;
		self.firstName = [userData objectForKey:@"first_name"];
		self.userId = [[userData objectForKey:@"user_id"] intValue];
		self.lastName = [userData objectForKey:@"last_name"];
		self.email = [userData objectForKey:@"email"];
		self.url = [userData objectForKey:@"url"];
		self.username = [userData objectForKey:@"username"];
		self.imageFullURLPath = [self.userData objectForKey:@"image"];
		self.imageURLPath = nil;
	}
	return self;
	
}

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
			NSLog(@"Loading image %@", imagePath);
			_imageURLPath = imagePath;
		}
	}
	return _imageURLPath;
	
}

/**
 Synchronized Request to get Image Data
 */
-(NSData *)fetchUserImageDataOverHTTP
{
	if (self.imageURLPath == nil)
	{
		return nil;
	}
	
	if (self.avatarData)
	{
		NSLog(@"cache hit with avatar data");
		return self.avatarData;
	
	}
		
    // Create the request.
	NSLog(@"Requesting Image Data over HTTP for %@", self.imageURLPath);
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:self.imageURLPath] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
	NSError        *error = nil;
	NSURLResponse  *response = nil;
	
	NSData *data =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse: &response error: &error];
	NSLog(@"Receiving Image Data for %@", self.imageURLPath);
	if (error)
	{
		NSLog(@"Error receiving Image Data %@: %@", self.imageURLPath, error);
	}
	self.avatarData = data;
	return data;
}


@end
