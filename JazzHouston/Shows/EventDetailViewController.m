//
//  EventDetailViewController.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/20/13.
//
//

#import "EventDetailViewController.h"
#import "EventListing.h"
#import "Venue.h"
#import "NSString+stripHTML.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

@synthesize eventId;
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
	[ApplicationDelegate.jazzHoustonEngine fetchShowDetails:self.eventId completionHandler:^(NSMutableDictionary *jsonResponse) {
		
		EventListing *eventListing  = [[EventListing alloc] initWithJSONData:[jsonResponse objectForKey:@"event"]];
		
		self.showAboutText.text = [eventListing.about stripHtml];
		self.showPerformerLabel.text = eventListing.performer;
		if (eventListing.venue.title != (id)[NSNull null])
			self.venueLabel.text = eventListing.venue.title;
		if (eventListing.venue.address != (id)[NSNull null])
			self.venueAddressLabel.text = eventListing.venue.address;
		if (eventListing.venue.phone != (id)[NSNull null])
			self.venuePhoneLabel.text = eventListing.venue.phone;
		
		self.showTimeLabel.text = eventListing.startTime;
		if (eventListing.typeOfEvent == 1)
			{
			NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
			[dateFormat setDateFormat:@"EEEE"];
			NSString *dateString = [dateFormat stringFromDate:eventListing.showDate];
			self.showDateLabel.text = dateString;
			} else {
				self.showDateLabel.text = eventListing.dayOfWeek;
		}
		
	}
   errorHandler:^(NSError* error) {
	   //TODO: implement
	   NSLog(@"Error message %@", error);
   }];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
	[super viewDidUnload];
}
@end
