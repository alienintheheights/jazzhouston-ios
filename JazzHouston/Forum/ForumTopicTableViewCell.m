//
//  ForumTopicTableViewCell.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/16/13.
//
//

#import "ForumTopicTableViewCell.h"
#import "ForumTopic.h"
#import "User.h"
#import "JazzHoustonAppDelegate.h"
#import "RoundedUIImage.h"

@implementation ForumTopicTableViewCell

@synthesize titleLabel = _titleLabel;
@synthesize authorLabel = _authorLabel;
@synthesize lastPostLabel = _lastPostLabel;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize numberOfPostsLabel = _numberOfPostsLabel;
@synthesize postCountBox = _postCountBox;

static int cornerRadius = 12.0f;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) setCellData:(ForumTopic *) forumTopic {
	User *currentUser = forumTopic.user;
	//[self.thumbnailImageView setImage:[UIImage imageNamed:@"forum-icon-blue.png"] ];
	// draw text into row
	self.titleLabel.text = forumTopic.title;
	self.authorLabel.text = currentUser.fullName;
	self.lastPostLabel.text = forumTopic.postDate;
	if (forumTopic.numberOfPosts>1) {
		self.postCountBox.backgroundColor = [UIColor redColor];
		self.numberOfPostsLabel.text = [NSString stringWithFormat:@"%d",forumTopic.numberOfPosts - 1];
		
	} else {
		self.postCountBox.backgroundColor = [UIColor clearColor];
		self.numberOfPostsLabel.text = @"";
	}
	
	if (currentUser.imageURLPath) {
		//TODO: protocol var, could be httpS
		NSString *imagePath = [NSString stringWithFormat:@"http://%@%@", HOSTNAME, currentUser.imageURLPath];
		[self.thumbnailImageView setImageFromURL:[NSURL URLWithString:imagePath]
								placeHolderImage:nil
									   animation:YES
							   imageLoadCallback:^(UIImage *fetchedImage) {
								   [self.thumbnailImageView setImage:[RoundedUIImage imageWithRoundedCornersSize:cornerRadius usingImage:fetchedImage]];
							   }
		 ];
		
	} else {
		[self.thumbnailImageView setImage:[RoundedUIImage imageWithRoundedCornersSize:12.0f usingImage:[UIImage imageNamed:@"forum-icon-blue.png"]]];
	}
}

/**
 For Use by the Segue
**/
-(int)fetchId:(ForumTopic *)forumTopic {
	return forumTopic.topicId;
}

@end
