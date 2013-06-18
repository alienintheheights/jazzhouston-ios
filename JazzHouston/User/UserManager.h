//
//  UserManager.h
//  JazzHouston
//
//  Created by Mr. Shoe on 6/16/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserManager : NSObject

+(id)userManagerInstance;
-(User *)fetchUserFromJSONData:(NSDictionary *)userData;

@end
