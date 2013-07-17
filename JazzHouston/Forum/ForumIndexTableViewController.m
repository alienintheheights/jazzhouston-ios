//
//  ForumTableViewController.m
//  SocialApp
//
//  Created by Andrew Lienhard on 3/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ForumIndexTableViewController.h"
#import "ForumTopicViewController.h"
#import "ForumTopicTableViewCell.h"
#import "ForumTopic.h"

@interface ForumIndexTableViewController ()
@property (nonatomic) BOOL isReload;

@end

@implementation ForumIndexTableViewController

@synthesize pageNumber = _pageNumber;
@synthesize boardId = _boardId;
@synthesize jsonTopics = _jsonTopics;
@synthesize isReload = _isReload;

// id the loading tag
int kLoadingCellTag = 1010;


- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		self.pageNumber = 0;
		self.jsonTopics = [[NSMutableArray alloc] init];
		self.isReload = NO;
	}
	return self;
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// sender is the tableview cell
	NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
	if ([segue.identifier isEqualToString:@"ForumTopics"])	{
		ForumTopicViewController *forumTopicVC = [segue destinationViewController];
		forumTopicVC.delegate = self;
		forumTopicVC.topicId = [sender fetchId:(self.jsonTopics)[indexPath.row]];
	}
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view


- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// add pull-to-refresh control
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refreshSelector:) forControlEvents:UIControlEventValueChanged];
    
	refreshControl.tintColor = [UIColor blueColor];
	self.refreshControl = refreshControl;
	

}


/**
 Run at start-up or with the back button, so adjust responses accordingly
 **/
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	// if page>1 we can assumer this is loading from the back button or other nav.
	// in order to save our place, do not reload the page in this case
	if (self.pageNumber > 1) {
		if (!self.isReload) {
			// snap back to the top
			NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
			[self.tableView selectRowAtIndexPath:topIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
		}
		self.isReload = NO;
		return;
	}
	self.pageNumber = 1;
	
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}


#pragma mark - Custom Forum Methods

-(void)setData:(int)topicId {
	if (topicId>0)
		self.isReload = YES;
}

/**
 Launches MKNetworkKit delegate
 Supports forced reload to skip cache and reset pageNumber
 Also starts and stops spinner animation
 **/
- (void)loadInBackground:(int)pageNumber
{
	
	// NOTE: the MKNetworkKit completion handler fires twice if cached.
	// We will know if it's a cached call via the param isCached
	// We also have a local array of data and current page to think about it
	[ApplicationDelegate.jazzHoustonEngine
		 fetchRemoteTopics:pageNumber
		 withForceReload:false
		 completionHandler:^(NSMutableArray* responseObject) {
		 
			 for (id forumPosts in responseObject ) {
				 ForumTopic *post = [[ForumTopic alloc] initWithJSONData:forumPosts];
				 if (![self.jsonTopics containsObject:post]) {
					 [self.jsonTopics addObject:post];
				 }
				 
			 }
	 
			 [self.tableView reloadData];
			 [self.refreshControl endRefreshing];
		 }
		 errorHandler:^(NSError* error) {
			 NSLog(@"Error: %@", [error localizedDescription]);
			 [[[UIAlertView alloc] initWithTitle:@"Error fetching forum posts"
										  message:@"Please try again later"
										 delegate:nil
								cancelButtonTitle:@"OK"
								otherButtonTitles:nil] show];
		 }];
	
}


- (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]
                                                  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.center;
    [cell addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    cell.tag = kLoadingCellTag;
    
    return cell;
}



- (UITableViewCell *)forumCellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"ForumTopicTableViewCell";
	ForumTopicTableViewCell *cell;
	cell = (ForumTopicTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[ForumTopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	ForumTopic *thisForumPost = (self.jsonTopics)[indexPath.row];
	if (thisForumPost)
		[cell setCellData:thisForumPost];
	return cell;
}



- (void)refreshSelector:(UIButton*)sender{
	// reset data and start from the top
	self.jsonTopics = [[NSMutableArray alloc] init];
	self.pageNumber = 1;
	[self loadInBackground:self.pageNumber];
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < [self.jsonTopics count]) {
        return [self forumCellForRowAtIndexPath:indexPath];
    } else {
        return [self loadingCell];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (cell.tag == kLoadingCellTag) {
        [self loadInBackground:++self.pageNumber];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of rows in the section.
    // If data source is yet empty, then return 0 cell.
    // If data source is not empty, then return one more cell space.
    // (for displaying the "Loading More..." text)
    if ([self.jsonTopics count] == 0) {
        return 1;
    } else {
        return [self.jsonTopics count] + 1;
    }
}



@end
