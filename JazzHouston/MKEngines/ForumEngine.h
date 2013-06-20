//
//  ForumEngine.h
//  JazzHouston
//
//  Created by Mr. Shoe on 6/18/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface ForumEngine : MKNetworkEngine


typedef void (^ForumTopicsResponseBlock)(NSMutableArray* jsonTopics, BOOL isCached);


-(void) fetchRemoteTopics:(int)pageNumber
		  withForceReload:(BOOL)forceReload
		completionHandler:(ForumTopicsResponseBlock)forumCellBlock
			 errorHandler:(MKNKErrorBlock)errorBlock;

-(void) fetchRemotePostsByTopicId:(int)topicId forPageNumber:(int)pageNumbe
				completionHandler:(ForumTopicsResponseBlock)forumCellBlock
					 errorHandler:(MKNKErrorBlock)errorBlock;


@end
