//
//  ForumTableViewController.h
//  SocialApp
//
//  Created by Andrew Lienhard on 3/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JazzHoustonAppDelegate.h"
#import "JazzHoustonViewController.h"


@protocol ForumShareDelegate

-(void)setData:(int)topicId;

@end

@interface ForumIndexTableViewController : JazzHoustonViewController <ForumShareDelegate>

#define PER_PAGE 10

@property (nonatomic, strong) NSString *boardId;
@property (nonatomic) int pageNumber;
@property (strong, nonatomic) NSMutableArray *jsonTopics;

@end
