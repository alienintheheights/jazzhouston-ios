//
//  ForumTopicList.m
//  SocialApp
//
//  Created by Andrew Lienhard on 3/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ForumDataController.h"

@interface ForumDataController()

@property (nonatomic, strong) NSArray *forumBoardJSONData;
@property (nonatomic, strong) NSArray *forumTopicJSONData;

@end

@implementation ForumDataController

#define JH_FORUM_INDEX_URL @"http://jazzhouston.com/forums/index.json"
#define JH_FORUM_MESSAGE_BASE_URL @"http://jazzhouston.com/forums/messages/"
#define HTTP_TIMEOUT 60.0

@synthesize forumBoardJSONData = _forumBoardJSONData;
@synthesize forumTopicJSONData = _forumTopicJSONData;


-(ForumTopic *)getForumTopicsByRow:(int) row
{
	NSDictionary *tempDictionary= [self.forumBoardJSONData objectAtIndex:row];
	return [[ForumTopic alloc] initWithJSONData:[tempDictionary objectForKey:@"topic"]];
	
}

-(int)numberOfTopicsByBoard
{
	if (!self.forumBoardJSONData) {
		return 0;
	}
	
	return [self.forumBoardJSONData count];
}

/**
 Synchronous HTTP request: 
	must be invoked in a separate Thread, not the main UI Thread.
 */
-(NSArray *) loadRemoteJSONBoardData {
    
    // Create the request.
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:JH_FORUM_INDEX_URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_TIMEOUT];
	NSError        *error = nil;
	NSURLResponse  *response = nil;
	
	NSData *data =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse: &response error: &error];
	NSLog(@"Receiving Data ");
	if (error) {
		NSLog(@"Deal with error %@", error);
	}
	
	self.forumBoardJSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	return self.forumBoardJSONData;
	 
}


-(ForumPost *)getForumPostsByRow:(int) row
{
	NSDictionary *tempDictionary= [self.forumTopicJSONData objectAtIndex:row];
	NSLog(@"forum post %@", tempDictionary);
	return [[ForumPost alloc] initWithJSONData:[tempDictionary objectForKey:@"post"]];
	
}

-(int)numberOfPostsByTopic
{
	if (!self.forumTopicJSONData) {
		return 0;
	}
	
	return [self.forumTopicJSONData count];
}


/**
 Synchronous HTTP request:
 must be invoked in a separate Thread, not the main UI Thread.
 */
-(NSArray *) loadRemoteJSONTopicDataById:(int)topicId {
    
	NSArray *anArray = [NSArray arrayWithObjects:JH_FORUM_MESSAGE_BASE_URL, [NSString stringWithFormat:@"%d", topicId], @".json", nil];
	NSString *requestPath = [anArray componentsJoinedByString:@""];
	NSLog(@"Requesting Forum Topic %@", requestPath);
	
    // Create the request.
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:requestPath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_TIMEOUT];
	NSError        *error = nil;
	NSURLResponse  *response = nil;
	
	NSData *data =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse: &response error: &error];
	NSLog(@"Receiving Data" );
	if (error) {
		NSLog(@"Deal with error %@", error);
	}
	self.forumTopicJSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	
	NSLog(@"Deal with data %@", self.forumTopicJSONData);
	return self.forumTopicJSONData;
	
}







@end
