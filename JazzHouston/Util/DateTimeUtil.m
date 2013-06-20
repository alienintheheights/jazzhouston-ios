//
//  DateTimeUtil.m
//  JazzHouston
//
//  Created by Mr. Shoe on 6/19/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "DateTimeUtil.h"

@implementation DateTimeUtil

#define DEFAULT_FORMAT_STRING @"yyyy-MM-dd'T'HH:mm:ssZZZZ"

+(id)dateTimeUtilInstance {
	static TTTTimeIntervalFormatter *_timeIntervalFormatter = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_timeIntervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
		[_timeIntervalFormatter setLocale:[NSLocale currentLocale]];
	});
	return _timeIntervalFormatter;
}

+(NSString *)dateInWords:(NSString *)inDate {
	return [DateTimeUtil dateInWords:inDate withDateFormat:DEFAULT_FORMAT_STRING];
}

+(NSString *)dateInWords:(NSString *)inDateString withDateFormat:(NSString *)dateFormatString {
	
	TTTTimeIntervalFormatter *_timeIntervalFormatter = [DateTimeUtil dateTimeUtilInstance];
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:dateFormatString];
	NSDate *inDate = [dateFormat dateFromString:inDateString];

    
	NSTimeInterval timeInterval = [inDate timeIntervalSinceDate:[NSDate date] ];
	
	return [_timeIntervalFormatter stringForTimeInterval:timeInterval];
	
}

@end
