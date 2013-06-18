//
//  ForumTableViewController.m
//  SocialApp
//
//  Created by Andrew Lienhard on 3/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ForumIndexTableViewController.h"
#import "ForumTopicViewController.h"
#import "AsyncImageView.h"
#import "ForumDataController.h"
#import "ForumTopic.h"
#import "User.h"
#import "ForumTopicTableViewCell.h"
#import "RoundedUIImage.h"

@interface ForumIndexTableViewController ()

@property (nonatomic, strong) ForumDataController *forumDataController;

@end

@implementation ForumIndexTableViewController

@synthesize forumDataController = _forumDataController;
@synthesize boardId = _boardId;

int PAGE_NUM = 1;

-(void)awakeFromNib
{
	 self.forumDataController = [ForumDataController forumDataControllerInstance];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	NSLog(@"initWithCoder");
	if ((self = [super initWithCoder:aDecoder])) {
		
        self.forumDataController = [ForumDataController forumDataControllerInstance];
    }	
    return self;
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
	cell.titleLabel.text = @"";
	cell.authorLabel.text = @"";
	
	// TODO: handle case where returned data is empty (i.e., erase the "loading data" message)
	if ([self.forumDataController numberOfTopics]==0)
	{
		return cell;
	} 
	
	// extract data for this row
	ForumTopic *forumPost = [self.forumDataController getForumTopicsByRow:indexPath.row];
	User *currentUser = forumPost.user;
		
	// draw text into row
	cell.titleLabel.text = forumPost.title;
	cell.authorLabel.text = currentUser.fullName;
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"MM/dd/yyyy HH:mm a"];
	NSString *dateString = [dateFormat stringFromDate:forumPost.postDate];
	cell.lastPostLabel.text = dateString;
	
	cell.numberOfPostsLabel.text = [NSString stringWithFormat:@"%d",forumPost.numberOfPosts - 1];
	
	[currentUser loadImageData:^{
		cell.thumbnailImageView.image = currentUser.imageData;
	}];
	
		
	
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
	PAGE_NUM = 1; //reset count
	[self loadInBackground:PAGE_NUM andAppend:false];
}

- (void)viewDidLoad
{
	[super viewDidLoad];	
	// add pull-to-refresh control
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(refreshSelector:) forControlEvents:UIControlEventValueChanged];
    
	refreshControl.tintColor = [UIColor blueColor];
	self.refreshControl = refreshControl;
	 
	[self loadInBackground:PAGE_NUM andAppend:false];
	self.tableView.rowHeight = 120;
}


- (void)loadInBackground:(int)pageNum andAppend:(BOOL)append
{
	if (!pageNum)
		pageNum = 1;
		
	[ForumDataController loadTopicsInBackground:pageNum andAppend:append completion:^{
		[self.tableView reloadData];
		[self.refreshControl endRefreshing];
    }];

}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender	
{
	// sender is the tableview cell
	NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
	if ([segue.identifier isEqualToString:@"ForumTopics"])
	{
		ForumTopic *forumTopic = [self.forumDataController getForumTopicsByRow:indexPath.row];
		ForumTopicViewController *forumTopicVC = [segue destinationViewController];
		forumTopicVC.topicId = forumTopic.topicId;
	}
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int rows = [self.forumDataController numberOfTopics];
	return (rows > 0) ?  rows : 1; // faulty logic, rows = 0 too
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	
	NSInteger currentOffset = scrollView.contentOffset.y;
	NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
	
	
	if (maximumOffset - currentOffset <= -40) {
		// TODO: add loading image/animation

		[self loadInBackground:++PAGE_NUM andAppend:true];
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
