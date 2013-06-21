//
//  MusicianTableViewCell.m
//  JazzHouston
//
//  Created by Mr. Shoe on 6/20/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "MusicianTableViewCell.h"
#import "UserManager.h"

@implementation MusicianTableViewCell

@synthesize musicianName = _musicianName;
@synthesize thumbnailImageView = _thumbnailImageView;
@synthesize phoneLabel = _phoneLabel;
@synthesize emailLabel = _emailLabel;

UserManager *userManager;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void) setCellData:(NSDictionary *)thisPlayer {
	
	userManager = [UserManager userManagerInstance];
	
	User *currentUser = [userManager fetchUserFromJSONData:[thisPlayer objectForKey:@"user"]];
	self.musicianName.text = currentUser.fullName;
	
	self.phoneLabel.text = @"";
	if (currentUser.cellPhone != (NSString *)[NSNull null]) {
		self.phoneLabel.text = currentUser.cellPhone;
	}
	self.emailLabel.text = @"";

	if (currentUser.email != (NSString *)[NSNull null]) {
		self.emailLabel.text = currentUser.email;
	}
	if (currentUser.imageURLPath) {
		NSString *imagePath = [NSString stringWithFormat:@"http://jazzhouston.com/%@", currentUser.imageURLPath];
		[self.thumbnailImageView setImageFromURL:[NSURL URLWithString:imagePath] placeHolderImage:nil];
	} else {
		[self.thumbnailImageView setImage:DEFAULT_IMAGE];
	}
	
}



@end
