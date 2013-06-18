//
//  User.h
//  SocialApp
//
//  Created by Andrew Lienhard on 3/13/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject 

@property (nonatomic, strong) NSDictionary *userData;
@property (nonatomic, strong) NSString *imageURLPath;
@property (nonatomic, strong) NSString *imageFullURLPath;
@property (nonatomic) int userId;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) UIImage *imageData;

+(id)fetchUserImageDataOverHTTP:(NSString *)userData;

-(void)loadImageData:(void(^)(void))callback;

@end
