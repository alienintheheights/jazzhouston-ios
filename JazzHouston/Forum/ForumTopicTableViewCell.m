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

@implementation ForumTopicTableViewCell


#define DEFAULT_IMAGE [UIImage imageNamed:@"forum-icon-blue.png"]

@synthesize titleLabel = _titleLabel;
@synthesize authorLabel = _authorLabel;
@synthesize lastPostLabel = _lastPostLabel;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize numberOfPostsLabel = _numberOfPostsLabel;

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

-(void) setCellData:(NSDictionary *) forumTopicData {
	ForumTopic *forumTopic = [[ForumTopic alloc] initWithJSONData:forumTopicData];
	User *currentUser = forumTopic.user;
	
	// draw text into row
	self.titleLabel.text = forumTopic.title;
	self.authorLabel.text = currentUser.fullName;
	self.lastPostLabel.text = forumTopic.postDate;
	
	self.numberOfPostsLabel.text = [NSString stringWithFormat:@"%d",forumTopic.numberOfPosts - 1];
	if (currentUser.imageURLPath) {
		NSString *imagePath = [NSString stringWithFormat:@"http://jazzhouston.com/%@", currentUser.imageURLPath];
		[self.thumbnailImageView setImageFromURL:[NSURL URLWithString:imagePath] placeHolderImage:nil];
	} else {
		[self.thumbnailImageView setImage:DEFAULT_IMAGE];
	}
}


-(int)fetchTopicId:(NSDictionary *)forumTopicData {
	ForumTopic *forumTopic = [[ForumTopic alloc] initWithJSONData:forumTopicData];
	return forumTopic.topicId;
}

@end
