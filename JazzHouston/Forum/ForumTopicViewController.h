//
//  ForumTopicViewController.h
//  SocialApp
//
//  Created by Mr. Shoe on 3/15/13.
//
//

#import <UIKit/UIKit.h>

@interface ForumTopicViewController : UITableViewController

@property (nonatomic) int topicId;

@property (strong, nonatomic) NSMutableArray *topicPosts;


@end
