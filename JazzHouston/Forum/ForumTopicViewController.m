//
//  ForumTopicViewController.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/15/13.
//
//

#import "ForumTopicViewController.h"
#import "AsyncImageView.h"
#import "ForumDataController.h"
#import "ForumPost.h"
#import "ForumPostTableViewCell.h"
#import "User.h"
#import "NSString+stripHTML.h"
#import "RoundedUIImage.h"


@interface ForumTopicViewController ()

@property (nonatomic, strong) ForumDataController *forumDataController;


@end


@implementation ForumTopicViewController

@synthesize topicId	= _topicId;
@synthesize forumDataController = _forumData;

NSMutableDictionary *_sizeArray;


- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		
        self.forumDataController = [ForumDataController forumDataControllerInstance];
		_sizeArray = [[NSMutableDictionary alloc] init];

    }
	
    return self;
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	

	[ForumDataController loadPostsInBackground:self.topicId completion:^{
		for (int row = 0; row <[self.forumDataController numberOfPostsByTopic]; row++)
		{
			ForumPost *forumPost = [self.forumDataController getForumPostsByRow:row];
			CGSize constraintSize = CGSizeMake(300, 2000.0f);
			CGSize labelSize = [forumPost.messageBody sizeWithFont:[UIFont systemFontOfSize:13]
												 constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];			
			[_sizeArray setObject:[NSNumber numberWithInt:labelSize.height+80] forKey:[NSString stringWithFormat:@"%d", row]];
		}
		[self.tableView reloadData];
		
    }];


	
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int rows = [self.forumDataController numberOfPostsByTopic];
	return (rows > 0) ?  rows : 1; // faulty logic, rows = 0 too

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    static NSString *cellIdentifier = @"ForumTopicViewCell";
	ForumPostTableViewCell *cell;
	cell = (ForumPostTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[ForumPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
		
	}
	
	
	// TODO: handle case where returned data is empty (i.e., erase the "loading data" message)
	if ([self.forumDataController numberOfPostsByTopic]==0)
	{
		return cell;
		
	}
	
	// extract data for this row
	ForumPost *forumPost = [self.forumDataController getForumPostsByRow:indexPath.row];
	User *currentUser = forumPost.user;
	
	// draw text into row
	cell.fullName.text = currentUser.fullName;
	
	if (forumPost.rating != 0) {
		if (forumPost.rating>0)
			cell.likeCount.text = [NSString stringWithFormat:@"+%d",forumPost.rating];
		else
			cell.likeCount.text = [NSString stringWithFormat:@"%d",forumPost.rating];
	}
	
	// draw date
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MM/dd/yyyy HH:mm"];
	NSString *dateString = [dateFormat stringFromDate:forumPost.postDate];
	cell.postDate.text = dateString;
	
	//size the webview
	CGFloat rightMargin = 10.f;
    CGSize constraintSize = CGSizeMake(300.0f - rightMargin, 2000.0f);
    CGSize labelSize = [forumPost.messageBody sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraintSize ];
	forumPost.messageBody = [forumPost.messageBody stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<br>"];
	
	[_sizeArray setObject:[NSNumber numberWithInt:labelSize.height] forKey:[NSString stringWithFormat:@"%d", indexPath.row]];
	[cell.messageBodyWebView loadHTMLString:forumPost.messageBody  baseURL:nil];
	cell.messageBodyWebView.scrollView.scrollEnabled = NO;
	cell.messageBodyWebView.scrollView.bounces = NO;
	
	[currentUser loadImageData:^{
		cell.thumbnailImageView.image = currentUser.imageData;
	}];

	return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	if ([_sizeArray count]==0) {
		return 100;
	}
	int height = [[_sizeArray objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] intValue];
	height += JH_FORUM_MESSAGE_BODY_OFFSET;
	return height;
}


/**- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	
		
}**/




@end
