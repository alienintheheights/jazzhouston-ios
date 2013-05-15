//
//  ShowsDataController.h
//  SocialApp
//
//  Created by Mr. Shoe on 3/18/13.
//
//

#import <Foundation/Foundation.h>
#import "EventListing.h"

@interface EventsDataController : NSObject

- (int) numberOfShows;
- (EventListing *) getEventByRow:(int)row;
// direct HTTP call, no async. Call in separate thread via a block.
- (NSArray *) loadRemoteJSONShowData;


@end
