//
//  ForumPostTableViewCell.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/17/13.
//
//

#import "ForumPostTableViewCell.h"
#import "ForumPost.h"

@implementation ForumPostTableViewCell

@synthesize messageBodyWebView = _messageLabel;
@synthesize fullName = _fullName;
@synthesize authorLabel = _authorLabel;
@synthesize postDate = _postDate;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize likeCount = _likeCount;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		//UIWebView* webView = [[UIWebView alloc] initWithFrame: CGRectMake(0,75, 300.0f - rightMargin, labelSize.height)];
        self.messageBodyWebView = [[UIWebView alloc] initWithFrame:self.bounds];
        [self.messageBodyWebView setDelegate:self];
		
        // It's important that the webview doesn't autoresize when its parent's frame changes.
        [self.messageBodyWebView setAutoresizingMask:UIViewAutoresizingNone];
		
        [self.messageBodyWebView.scrollView setScrollEnabled:NO]; // Prevents scrolling in the webview.
        [self.messageBodyWebView.scrollView setScrollsToTop:NO]; // Keep the "scroll to top when the status is tapped" behavior.
		 
    }
    return self;
}


-(void) setCellData:(NSDictionary *) forumTopicData {
	
	ForumPost *forumPost = [[ForumPost alloc] initWithJSONData:forumTopicData];
	User *currentUser = forumPost.user;
	
	
	// draw text into row
	self.fullName.text = currentUser.fullName;
	
	if (forumPost.rating != 0) {
		if (forumPost.rating>0)
			self.likeCount.text = [NSString stringWithFormat:@"+%d", forumPost.rating];
		else
			self.likeCount.text = [NSString stringWithFormat:@"%d", forumPost.rating];
	}
	
	self.postDate.text = forumPost.postDate;
	
	forumPost.messageBody = [forumPost.messageBody stringByReplacingOccurrencesOfString:@"\r\n" withString:@"<br>"];
	
	[self.messageBodyWebView loadHTMLString:forumPost.messageBody  baseURL:nil];
	self.messageBodyWebView.scrollView.scrollEnabled = NO;
	self.messageBodyWebView.scrollView.bounces = NO;
		
	NSString *imagePath = [NSString stringWithFormat:@"http://jazzhouston.com/%@", currentUser.imageURLPath];
	[self.thumbnailImageView setImageFromURL:[NSURL URLWithString:imagePath] placeHolderImage:DEFAULT_IMAGE];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    webView.alpha = 0.f;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.alpha = 1.f;
}


@end
