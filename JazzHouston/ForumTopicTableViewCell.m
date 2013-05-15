//
//  ForumTopicTableViewCell.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/16/13.
//
//

#import "ForumTopicTableViewCell.h"

@implementation ForumTopicTableViewCell

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

@end
