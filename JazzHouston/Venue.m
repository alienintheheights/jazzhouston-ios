//
//  Venue.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/18/13.
//
//

#import "Venue.h"

@implementation Venue

@synthesize venueId = _venueId;
@synthesize title = _title;
@synthesize about = _about;
@synthesize url = _url;
@synthesize address = _address;
@synthesize phone = _phone;



-(id)initWithJSONData:(NSDictionary *)userData
{
	self = [super init];
	if (self)
	{
		self.title = [userData objectForKey:@"title"];
		self.venueId = [[userData objectForKey:@"venue_id"] intValue];
		self.address = [userData objectForKey:@"address"];
		self.phone = [userData objectForKey:@"phone"];
	}
	return self;
	
}



@end
