//
//  ForumPost.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/16/13.
//
//

#import "ForumPost.h"

@implementation ForumPost

@synthesize user = _user;
@synthesize author = _author;
@synthesize messageBody	= _messageBody;
@synthesize postDate = _postDate;
@synthesize topicId = _topicId;
@synthesize rating = _rating;


-(id)initWithJSONData:(NSDictionary *)userData
{
	self = [super init];
	if (self)
	{
		self.user = [[User alloc] initWithJSONData:[userData objectForKey:@"user"]];
		self.messageBody = [userData objectForKey:@"message_text"];
		self.author = [userData objectForKey:@"author"];
		self.topicId = [[userData objectForKey:@"thread_id"] intValue];
		self.rating = [[userData objectForKey:@"rating"] intValue];
	
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		//2013-03-06T11:50:27-06:00
		NSString *pdate = [userData objectForKey:@"pdate"];
		[dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZ"];
		NSDate *date = [dateFormat dateFromString:pdate];
		self.postDate = date;

	}
	return self;
	
}

@end
