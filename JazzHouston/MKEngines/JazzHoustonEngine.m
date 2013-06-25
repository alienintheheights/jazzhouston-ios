//
//  JazzHoustonEngine.m
//  JazzHouston
//
//  Created by Mr. Shoe on 6/21/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "JazzHoustonEngine.h"



#pragma mark - REST URLs

#define JH_LOGIN_URL @"/members/login.json"
#define JH_LOGOUT_URL @"/members/logout.json"
#define JH_SESSION_DUMP_URL @"/members/session_dump"

#define JH_FORUM_INDEX_URL(__PAGENUM__)  [NSString stringWithFormat:@"/forums/index.json?page=%d", __PAGENUM__]
#define JH_FORUM_TOPIC_URL(__TOPICID__, __PAGENUM__)  [NSString stringWithFormat:@"/forums/messages/%d.json?page=%d", __TOPICID__, __PAGENUM__]
#define JH_FORUM_REPLY_URL @"/forums/update"

#define LIST_INSTRUMENTS @"/musicians/list_instruments"
#define JH_MUSICIANS_BY_INST_URL(__INSTID__, __PAGENUM__)  [NSString stringWithFormat:@"/musicians/byinst/%d.json?page=%d", __INSTID__, __PAGENUM__]

#define JH_EVENT_INDEX_URL @"/events/index.json"
#define JH_EVENT_DETAILS_BASE_URL(__EVENTID__) [NSString stringWithFormat:@"/events/details/%d.json", __EVENTID__]

// Tuck away authToken
static NSString *authToken;

#pragma mark - Implementation
@implementation JazzHoustonEngine


-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"JazzHoustonCache"];
    return cacheDirectoryName;
}



#pragma mark - Login REST calls

-(void)login:(NSString *)username andPassword:(NSString *)password
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	
    [params setObject:username forKey:@"login"];
    [params setObject:password forKey:@"password"];
	 [params setObject:@"on" forKey:@"remember_me"];
	
    MKNetworkOperation *op = [self operationWithPath:JH_LOGIN_URL params:params httpMethod:@"POST"];
	
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
		NSLog(@"response auth string: %@", completedOperation.responseString);
		authToken = completedOperation.responseString;
	 } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
		 NSLog(@"Server error: %@", [error localizedDescription]);
	 }];
	
    [self enqueueOperation:op];
}

-(void)logout
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	
    MKNetworkOperation *op = [self operationWithPath:JH_LOGOUT_URL params:params httpMethod:@"GET"];
	
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
		NSLog(@"response auth string: %@", completedOperation.responseString);
		authToken = completedOperation.responseString;
	} errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
		NSLog(@"Server error: %@", [error localizedDescription]);
	}];
	
    [self enqueueOperation:op];
}


-(void)sessionDump
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
	
    MKNetworkOperation *op = [self operationWithPath:JH_SESSION_DUMP_URL params:params httpMethod:@"GET"];
	
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
		NSLog(@"response session dump string: %@", completedOperation.responseString);
		authToken = completedOperation.responseString;
	} errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
		NSLog(@"Server error: %@", [error localizedDescription]);
	}];
	
    [self enqueueOperation:op];
}


+(NSString *)getAuthToken {
	return authToken;
}


#pragma mark - Forum REST calls

-(void) fetchRemoteTopics:(int)pageNumber
		  withForceReload:(BOOL)forceReload
		completionHandler:(ResponseBlock)forumCellBlock
			 errorHandler:(MKNKErrorBlock)errorBlock {
	
	MKNetworkOperation *op = [self	operationWithPath:JH_FORUM_INDEX_URL(pageNumber)
											  params: nil
										  httpMethod:@"GET"
												 ssl: NO];
	
	[op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
		BOOL isFinished = [completedOperation isFinished];
		BOOL isCached = [completedOperation isCachedResponse];
		NSLog(@"Page Number %d. Is Cached? %d Is Finished? %d", pageNumber, isCached, isFinished);
		[completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
			forumCellBlock(jsonObject);
		}];
		
	} errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
		
		errorBlock(error);
	}];
	
	[self enqueueOperation:op forceReload:forceReload];
	
}

-(void) fetchRemotePostsByTopicId:(int)topicId
					forPageNumber:(int)pageNumber
				completionHandler:(ResponseBlock)topicCellBlock
					 errorHandler:(MKNKErrorBlock)errorBlock {
	
	MKNetworkOperation *op = [self	operationWithPath:JH_FORUM_TOPIC_URL(topicId, pageNumber)
											  params: nil
										  httpMethod:@"GET"
												 ssl: NO];
	
	[op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
		
		[completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
			topicCellBlock(jsonObject);
		}];
		
	} errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
		
		errorBlock(error);
	}];
	
	[self enqueueOperation:op];
}

// NSString *authenticityToken = [[request responseHeaders] objectForKey:@"X-Authenticity-Token"];

-(void) replyToTopic:(NSDictionary *)params
			completionHandler:(ResponseBlock)completionBlock
			errorHandler:(MKNKErrorBlock)errorBlock {
	
	
	NSLog(@"Posting to forum %@", params);
	
    MKNetworkOperation *op = [self operationWithPath:JH_FORUM_REPLY_URL
                                              params:params
                                          httpMethod:@"POST"];
	
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
		
		[completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
			completionBlock(jsonObject);
		}];
		
	} errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
		
		errorBlock(error);
	}];

    [self enqueueOperation:op];
	 
}



#pragma mark - Musician REST calls



-(void) fetchInstruments:(ResponseBlock)instrumentCellBlock
			errorHandler:(MKNKErrorBlock)errorBlock {
	
	MKNetworkOperation *op = [self	operationWithPath:LIST_INSTRUMENTS
											  params: nil
										  httpMethod:@"GET"
												 ssl: NO];
	
	[op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
		
		[completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
			instrumentCellBlock(jsonObject);
		}];
		
	} errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
		
		errorBlock(error);
	}];
	
	[self enqueueOperation:op];
	
}

-(void) fetchRemoteMusicians:(int)instId
			   forPageNumber:(int)pageNumber
			 withForceReload:(BOOL)forceReload
		   completionHandler:(ResponseBlock)musicianCellBlock
				errorHandler:(MKNKErrorBlock)errorBlock {
	
	MKNetworkOperation *op = [self	operationWithPath:JH_MUSICIANS_BY_INST_URL(instId, pageNumber)
											  params: nil
										  httpMethod:@"GET"
												 ssl: NO];
	
	[op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
		
		[completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
			musicianCellBlock(jsonObject);
		}];
		
	} errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
		
		errorBlock(error);
	}];
	
	[self enqueueOperation:op forceReload:forceReload];
	
}




#pragma mark - Shows REST calls



-(void) fetchShowsToday:(ResponseBlock)todaysCellBlock
			errorHandler:(MKNKErrorBlock)errorBlock {
	
	MKNetworkOperation *op = [self	operationWithPath:JH_EVENT_INDEX_URL
											  params: nil
										  httpMethod:@"GET"
												 ssl: NO];
	
	[op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
		
		[completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
			todaysCellBlock(jsonObject);
		}];
		
	} errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
		
		errorBlock(error);
	}];
	
	[self enqueueOperation:op];
	
}

-(void) fetchShowDetails:(int)eventId
		   completionHandler:(ResponseBlockDict)showCellBlock
				errorHandler:(MKNKErrorBlock)errorBlock {
	
	MKNetworkOperation *op = [self	operationWithPath:JH_EVENT_DETAILS_BASE_URL(eventId)
											  params: nil
										  httpMethod:@"GET"
												 ssl: NO];
	
	[op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
		
		[completedOperation responseJSONWithOptions:NSJSONReadingAllowFragments completionHandler:^(id jsonObject) {
			showCellBlock(jsonObject);
		}];
		
	} errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
		
		errorBlock(error);
	}];
	
	[self enqueueOperation:op ];
	
}

@end

