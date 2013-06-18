//
//  ForumTopicList.m
//  SocialApp
//
//  Created by Andrew Lienhard on 3/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ForumDataController.h"


@implementation ForumDataController

static NSMutableArray *_forumBoardJSONData;
static NSMutableArray *_forumTopicJSONData;

#pragma mark REST Constants

#define JH_FORUM_INDEX_URL @"http://jazzhouston.com/forums/index.json?page="
#define JH_FORUM_MESSAGE_BASE_URL @"http://jazzhouston.com/forums/messages/"
#define HTTP_TIMEOUT 60.0


#pragma mark Singleton Constructor

+(id)forumDataControllerInstance {
	static ForumDataController *sharedForumDataController = nil;
	static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedForumDataController = [[self alloc] init];
    });
	return sharedForumDataController;
}

-(id)init {
	if (self = [super init]) {
		// implement
	}
	return self;
}


#pragma mark Forum Topic Methods

/**
 Get topic info on forum home screen by row
 **/
-(ForumTopic *)getForumTopicsByRow:(int) row
{
	NSDictionary *tempDictionary= [_forumBoardJSONData objectAtIndex:row];
	return [[ForumTopic alloc] initWithJSONData:[tempDictionary objectForKey:@"topic"]];
	
}

/**
 Count of number of topics currently loaded
 **/
-(int)numberOfTopics
{
	if (!_forumBoardJSONData) {
		return 0;
	}
	return [_forumBoardJSONData count];
}


/**
 Spawn thread to make a synchronous load of the REST/JSON data
 **/
+ (void) loadTopicsInBackground:(int)pageNum andAppend:(BOOL)append completion:(void(^)(void))callback {
	if (!pageNum)
		pageNum = 1;
	// The Beauty of THREADING!!
	dispatch_queue_t downloadQueue = dispatch_queue_create("Forum Topics", NULL);
	dispatch_async(downloadQueue, ^{
		
		NSDictionary *responseJSON = [ForumDataController loadRemoteJSONBoardData:pageNum];
		_forumBoardJSONData = (append && _forumBoardJSONData) ? _forumBoardJSONData :  [[NSMutableArray alloc] init];
		
		if (_forumBoardJSONData != (id)[NSNull null]) {
			// build data
			for (id key in responseJSON) {
				[_forumBoardJSONData addObject:key];
			}

			dispatch_async(dispatch_get_main_queue(), callback);
		}
	});
}


/**
 Synchronous HTTP request:
 must be invoked in a separate Thread, not the main UI Thread.
 pageNum, the page in the result set
 */
+(NSDictionary *) loadRemoteJSONBoardData:(int)pageNum {
    
	NSString *boardUrl = [NSString stringWithFormat:@"%@%d", JH_FORUM_INDEX_URL, pageNum];
    // Create the request.
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:boardUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_TIMEOUT];
	NSError        *error = nil;
	NSURLResponse  *response = nil;
	NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse: &response error: &error];
	if (error) {
		NSLog(@"Deal with error %@", error);
		return nil;
	}
	return  [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	
	
}


#pragma mark Forum Posts Methods


/**
 Get current messages in topic by row
 **/
-(ForumPost *)getForumPostsByRow:(int) row
{
	NSMutableDictionary *tempDictionary= [_forumTopicJSONData objectAtIndex:row];
	return [[ForumPost alloc] initWithJSONData:[tempDictionary objectForKey:@"post"]];
	
}

/**
 Count of number of posts for a given topic 
**/
-(int)numberOfPostsByTopic
{
	if (!_forumTopicJSONData) {
		return 0;
	}
	
	return [_forumTopicJSONData count];
}


/**
 Spawn thread to make a synchronous load of the REST/JSON data
 **/
+ (void) loadPostsInBackground:(int)topicId completion:(void(^)(void))callback {
	_forumTopicJSONData = nil;
	dispatch_queue_t downloadQueue = dispatch_queue_create("Forum Posts By Topic", NULL);
	dispatch_async(downloadQueue, ^{
		[ForumDataController loadRemoteJSONTopicDataById:topicId]; // synchronous
		if (_forumTopicJSONData != (id)[NSNull null]) {
			dispatch_async(dispatch_get_main_queue(), callback);
		}
	});
}




/**
 Synchronous HTTP request:
    must be invoked in a separate Thread, not the main UI Thread.
 */
+(NSMutableArray *) loadRemoteJSONTopicDataById:(int)topicId {
    
	NSMutableArray *anArray = [NSArray arrayWithObjects:JH_FORUM_MESSAGE_BASE_URL, [NSString stringWithFormat:@"%d", topicId], @".json", nil];
	NSString *requestPath = [anArray componentsJoinedByString:@""];
	NSLog(@"Requesting Forum Topic %@", requestPath);
	
    // Create the request.
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:requestPath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_TIMEOUT];
	NSError        *error = nil;
	NSURLResponse  *response = nil;
	
	NSData *data =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse: &response error: &error];
	if (error) {
		NSLog(@"Deal with Topic error %@", error);
		return nil;
	}
	_forumTopicJSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	
	return _forumTopicJSONData;
	
}



@end
