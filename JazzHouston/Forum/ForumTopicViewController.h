//
//  ForumTopicViewController.h
//  SocialApp
//
//  Created by Mr. Shoe on 3/15/13.
//
//

#import <UIKit/UIKit.h>

#import "JazzHoustonViewController.h"
#import "ForumIndexTableViewController.h"





@interface ForumTopicViewController : JazzHoustonViewController


@property (nonatomic, weak) id<ForumShareDelegate> delegate;


@property (nonatomic) int topicId;

@property (strong, nonatomic) NSMutableArray *topicPosts;


@end
