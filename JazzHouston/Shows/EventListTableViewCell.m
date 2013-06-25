//
//  EventListTableViewCell.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/18/13.
//
//

#import "EventListTableViewCell.h"
#import "EventListing.h"
#import "UserManager.h"
#import "DateTimeUtil.h"


@implementation EventListTableViewCell

@synthesize dateLabel = _dateLabel;
@synthesize showLabel = _showLabel;
@synthesize venueLabel = _venueLabel;
@synthesize startTimeLabel	= _startTimeLabel;


UserManager *userManager;

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



-(void) setCellData:(NSDictionary *) thisShow {
	
	EventListing *eventListing  = [[EventListing alloc] initWithJSONData:[thisShow objectForKey:@"event"]];
	Venue *currentVenue = eventListing.venue;
	self.venueLabel.text = currentVenue.title;
	
	// draw text into row
	self.showLabel.text = eventListing.performer;
	self.startTimeLabel.text = eventListing.startTime;
	
	if (eventListing.typeOfEvent == 1) {
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"EEEE"];
		NSString *dateString = [dateFormat stringFromDate:eventListing.showDate];
		self.dateLabel.text = dateString;
	} else {
		self.dateLabel.text = eventListing.dayOfWeek;
	}
	NSLog(@" %@ %@", currentVenue.title, eventListing.performer);
}


/**
 For Use by the Segue
 **/
-(int)fetchId:(NSDictionary *)data {
	NSDictionary *showData = [data objectForKey:@"event"];
	int eid = [[showData objectForKey:@"event_id"] intValue];
	return eid;
}


@end
