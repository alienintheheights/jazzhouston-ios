//
//  ForumEngine.m
//  JazzHouston
//
//  Created by Mr. Shoe on 6/18/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "ForumEngine.h"


#pragma mark REST Constants

#define JH_FORUM_INDEX_URL(__PAGENUM__)  [NSString stringWithFormat:@"/forums/index.json?page=%d", __PAGENUM__]
#define JH_FORUM_TOPIC_URL(__TOPICID__, __PAGENUM__)  [NSString stringWithFormat:@"/forums/messages/%d.json?page=%d", __TOPICID__, __PAGENUM__]

@implementation ForumEngine

-(void) fetchRemoteTopics:(int)pageNumber
		  withForceReload:(BOOL)forceReload
		completionHandler:(ForumTopicsResponseBlock)forumCellBlock
			 errorHandler:(MKNKErrorBlock)errorBlock {
		
		MKNetworkOperation *op = [self	operationWithPath:JH_FORUM_INDEX_URL(pageNumber)
												  params: nil
											  httpMethod:@"GET"
													 ssl: NO];
		
		[op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
			
			[completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
				forumCellBlock(jsonObject, [completedOperation isCachedResponse]);
			}];
			
		} errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
			
			errorBlock(error);
		}];
		
		[self enqueueOperation:op forceReload:forceReload];
	
}

-(void) fetchRemotePostsByTopicId:(int)topicId
					forPageNumber:(int)pageNumber
				completionHandler:(ForumTopicsResponseBlock)topicCellBlock
					 errorHandler:(MKNKErrorBlock)errorBlock {
	
	MKNetworkOperation *op = [self	operationWithPath:JH_FORUM_TOPIC_URL(topicId, pageNumber)
											  params: nil
										  httpMethod:@"GET"
												 ssl: NO];
	
	[op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
		
		[completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
			topicCellBlock(jsonObject, [completedOperation isCachedResponse]);
		}];
		
	} errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
		
		errorBlock(error);
	}];
	
	[self enqueueOperation:op];
}

-(NSString*) cacheDirectoryName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    NSString *cacheDirectoryName = [documentsDirectory stringByAppendingPathComponent:@"JHTopics"];
    return cacheDirectoryName;
}

@end
