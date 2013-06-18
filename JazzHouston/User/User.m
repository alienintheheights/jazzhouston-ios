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


#define JH_USER_AVATAR_URL @"http://jazzhouston.com/user/image/"
#define JH_USER_AVATAR_URL_SUBPATH @"/avatar/"
#define DEFAULT_IMAGE [UIImage imageNamed:@"forum-icon-blue.png"]


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

/**
Convenience function for fullName
 **/
-(NSString *) fullName
{
	return [self.firstName stringByAppendingString:[@" " stringByAppendingString:self.lastName] ];
	
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


/**
 Loads imageData over REST
 Uses a callback
 **/
-(void)loadImageData:(void(^)(void))callback {
	
	if (self.imageData)
	{
	    NSLog(@"cache hit with avatar data %@ %@", self.fullName, self.imageURLPath);
		callback();
		return;
	}
	
	NSString *userAvatarImagePath = self.imageURLPath;
	if (!userAvatarImagePath) {
		self.imageData = DEFAULT_IMAGE;
		callback();
		return;
	}
	// TODO: cache image if already loaded: use a property in User to store imageData!
	// launch async callback for image, if needed
	dispatch_queue_t downloadQueue = dispatch_queue_create("jazzhouston user avatar", NULL);
	dispatch_async(downloadQueue, ^{
		NSData *imageData = [User fetchUserImageDataOverHTTP:self.imageURLPath];
		if (imageData != (id)[NSNull null]) {
			self.imageData = [RoundedUIImage imageWithRoundedCornersSize:10 usingImage:[UIImage imageWithData:imageData]];
			 NSLog(@"cache write with avatar data %@ %@", self.fullName, self.imageURLPath);
			dispatch_async(dispatch_get_main_queue(), callback);
		}
	});
	
}


/**
 Synchronized Static Request to get Image Data
 */
+(NSData *)fetchUserImageDataOverHTTP:(NSString *)imageURLPath
{
	if (imageURLPath == nil)
	{
		return nil;
	}
		
    // Create the request.
	//NSLog(@"Requesting Image Data over HTTP for %@", self.imageURLPath);
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:imageURLPath] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60.0];
	NSError        *error = nil;
	NSURLResponse  *response = nil;
	
	NSData *data =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse: &response error: &error];
	//NSLog(@"Receiving Image Data for %@", self.imageURLPath);
	if (error)
	{
		NSLog(@"Error receiving Image Data %@: %@", imageURLPath, error);
		return nil;
	}
	return data;
}


@end
