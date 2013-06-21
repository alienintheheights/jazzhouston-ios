//
//  UserManager.m
//  JazzHouston
//
//  Created by Mr. Shoe on 6/16/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "UserManager.h"
#import "User.h"

@implementation UserManager


static NSMutableDictionary *_userCache;

#pragma mark Singleton Constructor

+(id)userManagerInstance {
	static UserManager *sharedUserManager = nil;
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserManager = [[self alloc] init];
    });
	return sharedUserManager;
}

-(id)init {
	if (self = [super init]) {
		_userCache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

#pragma mark JSON Implementation Function

/**
 Maps JSON data to object values.
 **/
-(User *)fetchUserFromJSONData:(NSDictionary *)userData
{
	//TODO: should we have a cache of users here instead of reloading over and over for the same person....
	NSString *userId = [userData objectForKey:@"user_id"];
	// check cache
	User *cachedUser = [_userCache objectForKey:userId];
	if (cachedUser) {
		NSLog(@"Cache hit on %@", cachedUser.fullName);
		return cachedUser;
		
	}
	// instantiate user
	cachedUser = [[User alloc] init];
	cachedUser.userData = userData;
	cachedUser.firstName = [userData objectForKey:@"first_name"];
	cachedUser.userId = [userId intValue];
	cachedUser.lastName = [userData objectForKey:@"last_name"];
	cachedUser.email = [userData objectForKey:@"email"];
	cachedUser.url = [userData objectForKey:@"url"];
	cachedUser.username = [userData objectForKey:@"username"];
	cachedUser.imageFullURLPath = [cachedUser.userData objectForKey:@"image"];
	cachedUser.imageURLPath = nil;
	cachedUser.cellPhone = [cachedUser.userData objectForKey:@"cell_phone"];
	cachedUser.homePhone = [cachedUser.userData objectForKey:@"home_phone"];

	
	// cache
	//[_userCache setObject:cachedUser forKey:userId];
	
	return cachedUser;
}

-(void)updateUser:(User *)user {
	
	//TODO: should we have a cache of users here instead of reloading over and over for the same person....
	// check cache
	NSString *userId = [NSString stringWithFormat:@"%d", user.userId];
	User *cachedUser = [_userCache objectForKey:userId];
	if (cachedUser)
		[_userCache setObject:user forKey:userId];
}



@end
