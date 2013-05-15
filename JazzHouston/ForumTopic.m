//
//  ForumPost.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/14/13.
//
//

#import "ForumTopic.h"

@implementation ForumTopic

@synthesize user = _user;
@synthesize title = _title;
@synthesize author = _author;
@synthesize postDate = _postDate;


-(id)initWithJSONData:(NSDictionary *)userData
{
	self = [super init];
	if (self)
	{
		self.user = [[User alloc] initWithJSONData:[userData objectForKey:@"user"]];
		self.title = [userData objectForKey:@"title"];
		self.author = [userData objectForKey:@"author"];
		self.topicId = [[userData objectForKey:@"thread_id"] intValue];
		self.numberOfPosts = [[userData objectForKey:@"post_count"] intValue];
	
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		//2013-03-06T11:50:27-06:00
		NSString *pdate = [userData objectForKey:@"modified_date"];
		[dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
		NSDate *date = [dateFormat dateFromString:pdate];
		self.postDate = date;

	}
	return self;
	
}

@end
