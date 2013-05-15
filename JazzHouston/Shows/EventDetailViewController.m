//
//  EventDetailViewController.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/20/13.
//
//

#import "EventDetailViewController.h"
#import "EventListing.h"
#import "NSString+stripHTML.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

@synthesize eventId;
@synthesize eventListing;
@synthesize showAboutText;
@synthesize venueLabel;
@synthesize showPerformerLabel;
@synthesize showTimeLabel;
@synthesize showDateLabel;
@synthesize venueAddressLabel;
@synthesize venuePhoneLabel;


- (void)viewDidLoad
{
	[super viewDidLoad];
	self.showAboutText.text = [self.eventListing.about stripHtml];
	self.showPerformerLabel.text = self.eventListing.performer;
	if (self.eventListing.venue.title != (id)[NSNull null])
		self.venueLabel.text = self.eventListing.venue.title;
	if (self.eventListing.venue.address != (id)[NSNull null])
		self.venueAddressLabel.text = self.eventListing.venue.address;
	if (self.eventListing.venue.phone != (id)[NSNull null])
		self.venuePhoneLabel.text = self.eventListing.venue.phone;
	
	self.showTimeLabel.text = self.eventListing.startTime;
	if (self.eventListing.typeOfEvent == 1)
	{
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"EEEE"];
		NSString *dateString = [dateFormat stringFromDate:eventListing.showDate];
		self.showDateLabel.text = dateString;
	} else {
		self.showDateLabel.text = eventListing.dayOfWeek;
	}
	

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
	[self setShowPerformerLabel:nil];
	[self setShowAboutText:nil];
	[self setShowAboutText:nil];
	[self setVenueLabel:nil];
	[self setShowTimeLabel:nil];
	[self setShowDateLabel:nil];
	[self setVenueAddressLabel:nil];
	[self setShowAboutText:nil];
    [self setShowAboutText:nil];
	[self setVenuePhoneLabel:nil];
	[super viewDidUnload];
}
@end
