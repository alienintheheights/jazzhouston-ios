//
//  Venue.h
//  SocialApp
//
//  Created by Mr. Shoe on 3/18/13.
//
//

#import <Foundation/Foundation.h>

@interface Venue : NSObject


@property (nonatomic) int venueId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *about;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *phone;

-(id)initWithJSONData:(NSDictionary *)userData;

@end
