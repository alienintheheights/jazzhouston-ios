//
//  ForumPost.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/14/13.
//
//

#import "ForumTopic.h"
#import "UserManager.h"
#import "DateTimeUtil.h"

@implementation ForumTopic

@synthesize user = _user;
@synthesize title = _title;
@synthesize author = _author;
@synthesize postDate = _postDate;

UserManager *userManager;



-(id)initWithJSONData:(NSDictionary *)currentRow
{
	
	if (self = [super init]) {
		userManager = [UserManager userManagerInstance];
	}
	NSDictionary *userData = [currentRow objectForKey:@"topic"];
	self.user = [userManager fetchUserFromJSONData:[userData objectForKey:@"user"]];
	self.title = [userData objectForKey:@"title"];
	self.author = [userData objectForKey:@"author"];
	self.topicId = [[userData objectForKey:@"thread_id"] intValue];
	self.numberOfPosts = [[userData objectForKey:@"post_count"] intValue];
		
	NSString *pdate = [userData objectForKey:@"modified_date"];
	self.postDate = [DateTimeUtil dateInWords:pdate];
	
	return self;
	
}


@end
