//
//  EventListTableViewCell.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/18/13.
//
//

#import "EventListTableViewCell.h"

@implementation EventListTableViewCell

@synthesize dateLabel = _dateLabel;
@synthesize showLabel = _showLabel;
@synthesize venueLabel = _venueLabel;
@synthesize startTimeLabel	= _startTimeLabel;

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
