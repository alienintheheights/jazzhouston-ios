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

@interface ForumDataController : NSObject {
	
}

+ (id) forumDataControllerInstance;
+ (void) loadTopicsInBackground:(int)pageNum andAppend:(BOOL)append completion:(void(^)(void))callback;

- (int) numberOfTopics;
- (ForumTopic *) getForumTopicsByRow:(int)row;


+ (void) loadPostsInBackground:(int)topicId completion:(void(^)(void))callback;

- (int)numberOfPostsByTopic;
- (ForumPost *) getForumPostsByRow:(int)row;

@end
