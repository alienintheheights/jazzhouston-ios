//
//  ForumTableViewController.h
//  SocialApp
//
//  Created by Andrew Lienhard on 3/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumIndexTableViewController : UITableViewController

@property (nonatomic, strong) NSString *boardId;

@property (strong, nonatomic) NSMutableArray *forumTopics;

@end
