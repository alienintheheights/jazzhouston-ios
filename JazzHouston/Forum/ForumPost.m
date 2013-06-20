//
//  ForumPost.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/16/13.
//
//

#import "ForumPost.h"
#import "UserManager.h"
#import "DateTimeUtil.h"

@implementation ForumPost

@synthesize user = _user;
@synthesize author = _author;
@synthesize messageBody	= _messageBody;
@synthesize postDate = _postDate;
@synthesize topicId = _topicId;
@synthesize rating = _rating;

UserManager *userManager;


-(id)initWithJSONData:(NSDictionary *)currentRow
{
	
	if (self = [super init]) {
		userManager = [UserManager userManagerInstance];
	}
	NSDictionary *userData = [currentRow objectForKey:@"post"];


	self.user = [userManager fetchUserFromJSONData:[userData objectForKey:@"user"]];
	self.messageBody = [userData objectForKey:@"message_text"];
	self.author = [userData objectForKey:@"author"];
	self.topicId = [[userData objectForKey:@"thread_id"] intValue];
	self.rating = [[userData objectForKey:@"rating"] intValue];

	
	NSString *pdate = [userData objectForKey:@"pdate"];
	self.postDate = [DateTimeUtil dateInWords:pdate];
	
	
	
	return self;
	
}

@end
