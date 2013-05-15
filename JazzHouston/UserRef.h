//
//  UserRef.h
//  SocialApp
//
//  Created by Mr. Shoe on 3/13/13.
//
//

#import <Foundation/Foundation.h>
#import "User.h"

/**
 A Caching Framework for User Objects.
 IN PROGRESS.
 **/

@interface UserRef : NSObject


+(User *)fetchCachedUserByUserId:(int)userId;

@end
