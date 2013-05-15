//
//  EventListing.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/18/13.
//
//

#import "EventListing.h"
#import "Venue.h"

@interface EventListing()
{
	


}
@end

@implementation EventListing

@synthesize eventId = _eventId;
@synthesize performer = _performer;
@synthesize startTime = _startTime;
@synthesize about = _about;
@synthesize relatedUrl = _relatedUrl;

@synthesize typeOfEvent = _typeOfEvent;
@synthesize dayOfWeek = _dayOfWeek;
@synthesize showDate = _showDate;

@synthesize venue = _venue;


/**
 {"event":{"event_id":5374,"touring_flag":null,"type_of_steady":null,"venue_id":64,"day_of_week":1,"performer":"Core-tet","about":"Matt Reichl-piano\r\nColin Cumming-bass\r\nJordan Almes-drums \r\nCory Wilson-saxophones<br><br><i>\"...the music is fantastic, definetly the best thing i know of on a Monday night in Houston\" </i>- <b>Cory Wilson, bandleader</b><br>","show_time":"9pm - 12am","event_type_id":2,"featured_flag":0,"related_url":"","jh_pick_flag":0,"show_date":null,"artist_id":2793,"jam_flag":0}},
 **/

-(id)initWithJSONData:(NSDictionary *)userData
{
	self = [super init];
	if (self)
	{
		self.relatedUrl = [userData objectForKey:@"related_url"];
		self.performer = [userData objectForKey:@"performer"];
		self.eventId = [[userData objectForKey:@"event_id"] intValue];
		self.startTime = [userData objectForKey:@"show_time"] ;
		self.typeOfEvent= [[userData objectForKey:@"event_type_id"] intValue];
		self.about = [userData objectForKey:@"about"];
		self.venue = [[Venue alloc] initWithJSONData:[userData objectForKey:@"venue"]];

		
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		NSString *pdate = [userData objectForKey:@"show_date"];
		if (_typeOfEvent ==1 && [pdate length]>0)
		{
			[dateFormat setDateFormat:@"yyyy-MM-dd"];
			NSDate *date = [dateFormat dateFromString:pdate];
			self.showDate = date;
		} else {
			
			NSArray *_daysOfTheWeek = [NSArray arrayWithObjects:@"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thurday", @"Friday", @"Saturday", @"Sunday", nil];
			NSString *foo = [_daysOfTheWeek objectAtIndex:[[userData objectForKey:@"day_of_week"] intValue]];
			self.dayOfWeek = foo;
		}
	}
	return self;
	
}



@end
