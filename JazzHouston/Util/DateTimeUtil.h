//
//  DateTimeUtil.h
//  JazzHouston
//
//  Created by Mr. Shoe on 6/19/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTTTimeIntervalFormatter.h"

@interface DateTimeUtil : NSObject

+(NSString *)dateInWords:(NSString *)inDate;
+(NSString *)dateInWords:(NSString *)inDateString withDateFormat:(NSString *)dateFormatString;

@end
