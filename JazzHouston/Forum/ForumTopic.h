//
//  ForumPost.h
//  SocialApp
//
//  Created by Mr. Shoe on 3/14/13.
//
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface ForumTopic : NSObject

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *postDate;
@property (nonatomic) int topicId;
@property (nonatomic) int numberOfPosts;

-(id)initWithJSONData:(NSDictionary *)userData;

@end
