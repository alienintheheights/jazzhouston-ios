//
//  ShowsDataController.m
//  SocialApp
//
//  Created by Mr. Shoe on 3/18/13.
//
//

#import "EventsDataController.h"


@interface EventsDataController()

@property (nonatomic, strong) NSArray *eventJSONData;

@end

@implementation EventsDataController

#define JH_EVENT_INDEX_URL @"http://jazzhouston.com/events/index.json"
#define JH_EVENT_DETAILS_BASE_URL @"http://jazzhouston.com/events/details/"
#define HTTP_TIMEOUT 60.0

@synthesize eventJSONData = eventJSONData;

-(EventListing *)getEventByRow:(int) row
{
	NSDictionary *tempDictionary= [self.eventJSONData objectAtIndex:row];
	return [[EventListing alloc] initWithJSONData:[tempDictionary objectForKey:@"event"]];
	
}

-(int)numberOfShows
{
	if (!self.eventJSONData) {
		return 0;
	}
	
	return [self.eventJSONData count];
}

/**
 Synchronous HTTP request:
 must be invoked in a separate Thread, not the main UI Thread.
 */
-(NSArray *) loadRemoteJSONShowData {
    
    // Create the request.
    NSURLRequest *urlRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:JH_EVENT_INDEX_URL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:HTTP_TIMEOUT];
	NSError        *error = nil;
	NSURLResponse  *response = nil;
	
	NSData *data =[NSURLConnection sendSynchronousRequest:urlRequest returningResponse: &response error: &error];
	NSLog(@"Receiving Data" );
	if (error) {
		NSLog(@"Deal with error %@", error);
	}
	
	self.eventJSONData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	return self.eventJSONData;
	
}

@end
