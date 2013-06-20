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

@property (nonatomic) int pageNumber;

@end

@implementation ForumIndexTableViewController

@synthesize pageNumber = _pageNumber;
@synthesize boardId = _boardId;


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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[ApplicationDelegate.forumEngine fetchRemoteTopics:self.pageNumber
				completionHandler:^(NSMutableArray* jsonForumPosts) {
					// loop over hash elements to create array...
					self.forumTopics = [[NSMutableArray alloc] initWithArray:jsonForumPosts];
					[self.tableView reloadData];  
					
				}
				errorHandler:^(NSError* error) {
					 //TODO: implement
				}
	 ];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"ForumTopicTableViewCell";
	ForumTopicTableViewCell *cell;
	cell = (ForumTopicTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell)
	{
		cell = [[ForumTopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	NSDictionary *thisForumPost = (self.forumTopics)[indexPath.row];
	
    // code from Stanford Tutorial
    [cell setCellData:thisForumPost];
	return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.2];
        cell.backgroundColor = altCellColor;
    }
}

- (void)refreshSelector:(UIButton*)sender{
	// reset data and start from the top
	self.pageNumber = 1; //reset count
	[self loadInBackground:1 andAppend:NO];
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


- (void)loadInBackground:(int)pageNum andAppend:(BOOL)append
{
		
	[ApplicationDelegate.forumEngine
				fetchRemoteTopics:pageNum
				 completionHandler:^(NSMutableArray* jsonForumPosts) {
					 // loop over hash elements to create array...
					 if (!append) {
						 self.forumTopics = [[NSMutableArray alloc] init]; // let ARC clean it up
					 }
					 [self.forumTopics addObjectsFromArray:jsonForumPosts];
					 [self.refreshControl endRefreshing];
					 [self.tableView reloadData]; 
					 
				 }
				 errorHandler:^(NSError* error) {
					  //TODO: implement
				 }
	 ];

}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	 return [self.forumTopics count];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	
	NSInteger currentOffset = scrollView.contentOffset.y;
	NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
	
	
	if (maximumOffset - currentOffset <= -40) {
		// TODO: add loading image/animation

		[self loadInBackground:++self.pageNumber andAppend:true];
	}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
@end
