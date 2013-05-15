//
//  UserRef.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/13/13.
//
//

#import "UserRef.h"
#import "User.h"

@implementation UserRef

#define MAX_CACHE_SIZE 100

static NSMutableDictionary *_userCache;

// Singleton impl
+(User *)fetchCachedUserByUserId:(int)userId
{
	
	if (!_userCache) _userCache = [[NSMutableDictionary alloc] initWithCapacity:MAX_CACHE_SIZE];
	
	User *cachedUser = [_userCache objectForKey:[NSString stringWithFormat:@"%d", userId]];
	if (!cachedUser)
	{
		User *user = [[User alloc] init]; // Deal with INIT param
		[_userCache setObject:user forKey:[NSString stringWithFormat:@"%d", userId]];
		NSLog(@"Adding user to cache %d", userId);
	} else {
		NSLog(@"Cache hit %d", userId);
	}
	return cachedUser;
}

+(void)addUser:(User *)user
{
	@synchronized(self)
	{
		User *cachedUser = [_userCache objectForKey:[NSString stringWithFormat:@"%d", user.userId]];
		if (cachedUser)
		{
			return;
		}
		[_userCache setObject:user forKey:[NSString stringWithFormat:@"%d", user.userId]];
	}
	
}



@end
