//
//  EventListing.h
//  SocialApp
//
//  Created by Mr. Shoe on 3/18/13.
//
//

#import <Foundation/Foundation.h>
#import "Venue.h"

@interface EventListing : NSObject

typedef enum {
	SteadyGig=2,
	OneNighter=1
} EventType;

@property (nonatomic) int eventId;
@property (nonatomic, strong) NSString *performer;
@property (nonatomic, strong) NSString *about;
@property (nonatomic, strong) NSString *relatedUrl;
@property (nonatomic, strong) NSString *startTime;

@property (nonatomic) int typeOfEvent;
@property (nonatomic, strong) NSDate *showDate;
@property (nonatomic) NSString *dayOfWeek;

@property (nonatomic, strong) Venue *venue;



-(id)initWithJSONData:(NSDictionary *)userData;


@end
