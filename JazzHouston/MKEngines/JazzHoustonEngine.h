//
//  JazzHoustonEngine.h
//  JazzHouston
//
//  Created by Mr. Shoe on 6/21/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface JazzHoustonEngine : MKNetworkEngine

typedef void (^SimpleResponseBlock)(NSString* jsonResponse);

typedef void (^ResponseBlock)(NSMutableArray* jsonResponse);

typedef void (^ResponseBlockDict)(NSMutableDictionary* jsonResponse);

-(void)login:(NSString *)username
		andPassword:(NSString *)password
			completionHandler:(SimpleResponseBlock)loginBlock
				errorHandler:(MKNKErrorBlock)errorBlock;

-(void)logout;

-(void)checkSession:(SimpleResponseBlock)responseBlock
					   errorHandler:(MKNKErrorBlock)errorBlock;

-(void) fetchRemoteTopics:(int)pageNumber
		  withForceReload:(BOOL)forceReload
		completionHandler:(ResponseBlock)forumCellBlock
			 errorHandler:(MKNKErrorBlock)errorBlock;

-(void) fetchRemotePostsByTopicId:(int)topicId forPageNumber:(int)pageNumbe
				completionHandler:(ResponseBlock)forumCellBlock
					 errorHandler:(MKNKErrorBlock)errorBlock;


-(void) replyToTopic:(NSDictionary *)formFields
   completionHandler:(ResponseBlock)completionBlock
		errorHandler:(MKNKErrorBlock)errorBlock;


-(void) fetchInstruments:(ResponseBlock)instrumentCellBlock
			errorHandler:(MKNKErrorBlock)errorBlock;

-(void) fetchRemoteMusicians:(int)instId
			   forPageNumber:(int)pageNumber
			 withForceReload:(BOOL)forceReload
		   completionHandler:(ResponseBlock)musicianCellBlock
				errorHandler:(MKNKErrorBlock)errorBlock;

-(void) fetchShowsToday:(ResponseBlock)todaysCellBlock
		   errorHandler:(MKNKErrorBlock)errorBlock;

-(void) fetchShowDetails:(int)eventId
	   completionHandler:(ResponseBlockDict)showCellBlock
			errorHandler:(MKNKErrorBlock)errorBlock;


@end
