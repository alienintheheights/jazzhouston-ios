//
//  ForumTableViewController.m
//  SocialApp
//
//  Created by Andrew Lienhard on 3/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "JazzHoustonAppDelegate.h"
#import "ForumIndexTableViewController.h"
#import "ForumTopicViewController.h"
#import "ForumTopicTableViewCell.h"
#import "ForumTopic.h"

@interface ForumIndexTableViewController ()

#define PER_PAGE 10

@property (nonatomic) int pageNumber;

@end

@implementation ForumIndexTableViewController

@synthesize pageNumber = _pageNumber;
@synthesize boardId = _boardId;


- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		self.pageNumber=1;
		self.forumTopics = [[NSMutableArray alloc] init];
	}
	return self;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// sender is the tableview cell
	NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
	if ([segue.identifier isEqualToString:@"ForumTopics"])
		{
		ForumTopicViewController *forumTopicVC = [segue destinationViewController];
		forumTopicVC.topicId = [sender fetchTopicId:(self.forumTopics)[indexPath.row]];
		}
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}



#pragma mark - Custom Load Methods

- (void)refreshSelector:(UIButton*)sender{
	// reset data and start from the top
	[self loadInBackground:YES ];
}

/**
 Launches MKNetworkKit delegate
 Supports forced reload to skip cache and reset pageNumber
 Also starts and stops spinner animation
**/
- (void)loadInBackground:(BOOL)forceReload
{
	// TODO: combine w/ topictableviewC into a method--perhaps a common parent Controller too?
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(160, 60);
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];
	
	
	NSLog(@"attempting to fetch pageNumber %d", self.pageNumber);
	// The MK completion handler fires twice if cached.
	// We will know if it's a cached call via the param isCached
	// We also have a local array of data and current page to think about it
	[ApplicationDelegate.forumEngine
			fetchRemoteTopics:(forceReload)? 1: self.pageNumber
			  withForceReload:forceReload
			completionHandler:^(NSMutableArray* jsonForumPosts, BOOL isCached) {
				
				// if force re-init the array, but watch out for the MK double-load annoyance!
				if (forceReload && !isCached) {
					self.forumTopics = [[NSMutableArray alloc] init]; // let ARC clean it up
					if (self.pageNumber>1) self.pageNumber = 1; // reset
				}
				
				 // if forumTopics array is missing that page's data, add it to the array
				 //NSLog(@"current size of page %d is %d", self.pageNumber, [self.forumTopics count]);
				 // Do we already have this page's data?
				 if ([self.forumTopics count]<PER_PAGE*self.pageNumber) {
					 [self.forumTopics addObjectsFromArray:jsonForumPosts];
					 //NSLog(@"done fetching, about to reload with pageNumber %d", self.pageNumber);
					 [self.tableView reloadData];
					 self.pageNumber++; // enable next page
				 }
				 
				 [self.refreshControl endRefreshing];
				 [spinner stopAnimating];
				  NSLog(@"Am I cached forum topic data? %@", isCached ? @"YES" : @"NO");
				 
			 }
			 errorHandler:^(NSError* error) {
				 //TODO: implement
			 }];
	
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"ForumTopicTableViewCell";
	ForumTopicTableViewCell *cell;
	cell = (ForumTopicTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[ForumTopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	NSDictionary *thisForumPost = (self.forumTopics)[indexPath.row];
	
    [cell setCellData:thisForumPost];
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.forumTopics count];
}



#pragma mark - Table view



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	NSInteger currentOffset = scrollView.contentOffset.y;
	NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
	
	
	if (maximumOffset - currentOffset <= -40) {
		// TODO: add loading image/animation
		[self loadInBackground:false];
	}
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.2];
        cell.backgroundColor = altCellColor;
    }
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
		return;
	}
	
	[self loadInBackground:NO];
}



- (void)viewDidLoad
{
	[super viewDidLoad];
	// add pull-to-refresh control
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refreshSelector:) forControlEvents:UIControlEventValueChanged];
    
	refreshControl.tintColor = [UIColor blueColor];
	self.refreshControl = refreshControl;
	self.tableView.rowHeight = 120;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	NSLog(@"View will disappear, parent");
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}



@end
