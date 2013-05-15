//
//  ForumTopicList.h
//  SocialApp
//
//  Created by Andrew Lienhard on 3/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ForumTopic.h"
#import "ForumPost.h"

@class ForumTopic;
@class ForumPost;

@interface ForumDataController : NSObject

- (int) numberOfTopicsByBoard;
- (ForumTopic *) getForumTopicsByRow:(int)row;
// direct HTTP call, no async. Call in separate thread via a block.
- (NSArray *) loadRemoteJSONBoardData;


- (int)numberOfPostsByTopic;
- (ForumPost *) getForumPostsByRow:(int)row;
// direct HTTP call, no async. Call in separate thread via a block.
- (NSArray *) loadRemoteJSONTopicDataById:(int)topicId;

@end
