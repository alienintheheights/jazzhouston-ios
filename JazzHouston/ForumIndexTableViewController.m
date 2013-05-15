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

@interface ForumIndexTableViewController ()

@property (nonatomic, strong) ForumDataController *forumDataController;

@end

@implementation ForumIndexTableViewController

@synthesize forumDataController = _forumData;
@synthesize boardId = _boardId;

-(void)awakeFromNib
{
	 self.forumDataController = [[ForumDataController alloc] init];	
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	//NSLog(@"initWithCoder");
	if ((self = [super initWithCoder:aDecoder])) {
		
        self.forumDataController = [[ForumDataController alloc] init];		
    }
	
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//NSLog(@"starting cellForRowAtIndexPath");
	static NSString *cellIdentifier = @"ForumTopicTableViewCell";
	ForumTopicTableViewCell *cell;
	cell = (ForumTopicTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell)
	{
		cell = [[ForumTopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	// TODO: handle case where returned data is empty (i.e., erase the "loading data" message)
	if ([self.forumDataController numberOfTopicsByBoard]==0)
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
	
	
	NSString *userAvatarImagePath = currentUser.imageURLPath;
	if (!userAvatarImagePath) {
		UIImage *theImage = [UIImage imageNamed:@"forum-icon-blue.png"];
		cell.thumbnailImageView.image = theImage;
		return cell;
	}
	// TODO: cache image if already loaded: use a property in User to store imageData!
	// launch async callback for image, if needed
	dispatch_queue_t downloadQueue = dispatch_queue_create("jazzhouston user avatar", NULL);
	dispatch_async(downloadQueue, ^{
		NSData *imageData = [currentUser fetchUserImageDataOverHTTP];
		if (imageData != (id)[NSNull null]) {
			dispatch_async(dispatch_get_main_queue(), ^{
				//NSLog(@"building image view from avatar callback %@", currentUser.firstName);
				//make an image view for the image
				cell.thumbnailImageView.image = [UIImage imageWithData:imageData];
				
			});
		}
	});
	
	
	return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.2];
        cell.backgroundColor = altCellColor;
    }
}

- (void)viewDidLoad
{
	NSLog(@"starting viewDidLoad");
    [super viewDidLoad];
	
	
	// add pull-to-refresh control
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
										init];
	[refreshControl addTarget:self action:@selector(loadInBackground) forControlEvents:UIControlEventValueChanged];
    
	refreshControl.tintColor = [UIColor magentaColor];
	self.refreshControl = refreshControl;
	 
	// TODO: add pagination param
	[self loadInBackground];
}


// TODO: add pagination support
- (void)loadInBackground
{
	
	// The Beauty of THREADING!!
	dispatch_queue_t downloadQueue = dispatch_queue_create("jazzhouston forum topics", NULL);
	dispatch_async(downloadQueue, ^{
		[self.forumDataController loadRemoteJSONBoardData];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.tableView reloadData];
			[self.refreshControl endRefreshing];

		});
	});

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
	NSLog(@"I am preparing for segue with %@", indexPath);
	if ([segue.identifier isEqualToString:@"ForumTopics"])
	{
		ForumTopic *forumTopic = [self.forumDataController getForumTopicsByRow:indexPath.row];
		ForumTopicViewController *forumTopicVC = [segue destinationViewController];
		forumTopicVC.topicId = forumTopic.topicId;
		NSLog(@"I am switching to forum Topics vc %@", forumTopic.title);
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
	int rows = [self.forumDataController numberOfTopicsByBoard];
	return (rows > 0) ?  rows : 1; // faulty logic, rows = 0 too
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
