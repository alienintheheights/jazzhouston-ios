//
//  ForumTopicViewController.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/15/13.
//
//


#import "JazzHoustonAppDelegate.h"
#import "ForumTopicViewController.h"
#import "ForumPost.h"
#import "ForumPostTableViewCell.h"
#import "NSString+Sizer.h"
#import "ForumReplyButton.h"
#import "ForumReplyViewController.h"



#define JH_FORUM_MESSAGE_BODY_OFFSET 150


@interface ForumTopicViewController ()

@property (nonatomic) int pageNumber;
@property (nonatomic) NSMutableDictionary *sizeDict;


@end


@implementation ForumTopicViewController


@synthesize topicId	= _topicId;
@synthesize pageNumber = _pageNumber;
@synthesize sizeDict = _sizeDict;

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		 self.pageNumber=1;
	}
	return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	//[self.parentViewController ];
	NSLog(@"View will disappear, child");
	[self.delegate setData:self.topicId ];
}

-(void)openReplyView:(ForumReplyButton *)sender {
	
	[self performSegueWithIdentifier:@"ForumReply" sender:sender];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// sender is the tableview cell
	if ([segue.identifier isEqualToString:@"ForumReply"]) {
		ForumReplyViewController *fvc = [segue destinationViewController];
		fvc.topicId = [NSNumber numberWithInt:self.topicId];
	}
}


/**
 Turns on loading spinner
 Fetches remote data
 Builds size dictionary during callback (sigh...)
 Reloads Table
 Turns off spinner
 **/
- (void)viewDidAppear:(BOOL)animated
{
	
	
	UIActivityIndicatorView *spinner = self.animate;
	
	[ApplicationDelegate.jazzHoustonEngine
					 fetchRemotePostsByTopicId:self.topicId
								 forPageNumber:self.pageNumber
					         completionHandler:^(NSMutableArray* jsonForumPosts) {
								
								 self.topicPosts = [[NSMutableArray alloc] initWithArray:jsonForumPosts];
								 self.sizeDict = [[NSMutableDictionary alloc] init];
								 // because each size is a dynamically-sized. I wish there was an easier way.
								 for (int row = 0; row <[self.topicPosts count]; row++)
								 {
									 ForumPost *forumPost = [[ForumPost alloc] initWithJSONData:(self.topicPosts)[row] ];
									 CGSize constraintSize = CGSizeMake(300, 2000.0f);
									 CGSize labelSize = [forumPost.messageBody
															  sizeWithFont:[UIFont systemFontOfSize:13]
													     constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
								 
									 int rawHeight = labelSize.height + JH_FORUM_MESSAGE_BODY_OFFSET;
									 NSNumber *height = [NSNumber numberWithInt:rawHeight] ;
									 [self.sizeDict setObject:height forKey:[NSString stringWithFormat:@"%d", row]];
								 }
								 [spinner stopAnimating];
								 [self.tableView reloadData];										 
					 }
					 errorHandler:^(NSError* error) {
						  //TODO: implement
					 }
	 ];
	
    [super viewDidAppear:animated];
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	// add pull-to-refresh control
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	//[refreshControl addTarget:self action:@selector(refreshSelector:) forControlEvents:UIControlEventValueChanged];
    
	refreshControl.tintColor = [UIColor blueColor];
	self.refreshControl = refreshControl;
	
	ForumReplyButton *myButton = [ForumReplyButton buttonWithType:UIButtonTypeCustom];
	[myButton setTitle:@"Reply" forState:UIControlStateNormal];
	myButton.showsTouchWhenHighlighted = YES;
	myButton.frame = CGRectMake(0.0, 0.0, 50, 50);
	
	[myButton addTarget:self action:@selector(openReplyView:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:myButton];
	self.navigationItem.rightBarButtonItem = rightButton;

}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    static NSString *cellIdentifier = @"ForumTopicViewCell";
	ForumPostTableViewCell *cell;
	cell = (ForumPostTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[ForumPostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	NSLog(@"Current Row %d", indexPath.row);

	
	NSDictionary *thisForumPost = (self.topicPosts)[indexPath.row];
	
    [cell setCellData:thisForumPost];
	return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.topicPosts count];
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
	// Yes, a fucking size dictionary. I guess iOS doesn't really like it's table cell heights to vary.
	int height = [[self.sizeDict objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]] intValue] ;
	return height;
}





@end
