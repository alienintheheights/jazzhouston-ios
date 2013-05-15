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


@interface ForumTopicViewController ()

@property (nonatomic, strong) ForumDataController *forumDataController;


@end


@implementation ForumTopicViewController

@synthesize topicId	= _topicId;
@synthesize forumDataController = _forumData;

NSMutableDictionary *_sizeArray;


- (id)initWithCoder:(NSCoder *)aDecoder
{
	NSLog(@"initWithCoder");
	if ((self = [super initWithCoder:aDecoder])) {
		
        self.forumDataController = [[ForumDataController alloc] init];
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
    NSLog(@"starting topic %d viewDidLoad", self.topicId);
    [super viewDidLoad];
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
										initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	spinner.center = CGPointMake(160, 240);
	spinner.hidesWhenStopped = YES;
	[self.view addSubview:spinner];
	[spinner startAnimating];
	
	// The Beauty of THREADING!!
	dispatch_queue_t downloadQueue = dispatch_queue_create("jazzhouston forum message", NULL);
	dispatch_async(downloadQueue, ^{
		[self.forumDataController loadRemoteJSONTopicDataById:self.topicId];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			for (int row = 0; row <[self.forumDataController numberOfPostsByTopic]; row++)
			{
					ForumPost *forumPost = [self.forumDataController getForumPostsByRow:row];
					CGSize constraintSize = CGSizeMake(300, 2000.0f);
					CGSize labelSize = [forumPost.messageBody sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
					NSLog(@"%@", forumPost.messageBody);
		
					[_sizeArray setObject:[NSNumber numberWithInt:labelSize.height+50] forKey:[NSString stringWithFormat:@"%d", row]];
			}
			[spinner stopAnimating];
			[self.tableView reloadData];
		});
	});

	
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int rows = [self.forumDataController numberOfPostsByTopic];
	return (rows > 0) ?  rows : 1; // faulty logic, rows = 0 too

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"starting cellForRowAtIndexPath");
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
    CGSize labelSize = [forumPost.messageBody sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
	forumPost.messageBody = [forumPost.messageBody stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<br>"];
	
	[_sizeArray setObject:[NSNumber numberWithInt:labelSize.height] forKey:[NSString stringWithFormat:@"%d", indexPath.row]];
	[cell.messageBodyWebView loadHTMLString:forumPost.messageBody  baseURL:nil];
	
	// launch async callback for image, if needed
	NSString *userAvatarImagePath = currentUser.imageURLPath;
	if (!userAvatarImagePath) {
		UIImage *theImage = [UIImage imageNamed:@"forum-icon-blue.png"];
		cell.thumbnailImageView.image = theImage;
		return cell;
	}
	
	// TODO: cache image if already loaded: use a property in User to store imageData!
	dispatch_queue_t downloadQueue = dispatch_queue_create("jazzhouston user avatar", NULL);
	dispatch_async(downloadQueue, ^{
		NSData *imageData = [currentUser fetchUserImageDataOverHTTP];
		if (imageData != (id)[NSNull null]) {
			dispatch_async(dispatch_get_main_queue(), ^{
				NSLog(@"building image view from avatar callback %@", currentUser.firstName);								
				cell.thumbnailImageView.image = [UIImage imageWithData:imageData];
			});
		}
	});	
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
/**

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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
