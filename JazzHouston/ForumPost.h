//
//  ForumPost.h
//  SocialApp
//
//  Created by Mr. Shoe on 3/16/13.
//
//

#import <Foundation/Foundation.h>
#import "User.h"


@interface ForumPost : NSObject

@property (nonatomic, strong) User *user;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *messageBody;
@property (nonatomic, strong) NSDate *postDate;
@property (nonatomic) int topicId;
@property (nonatomic) int rating;

-(id)initWithJSONData:(NSDictionary *)userData;

@end
