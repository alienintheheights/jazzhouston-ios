//
//  ForumPostTableViewCell.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/17/13.
//
//

#import "ForumPostTableViewCell.h"

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
