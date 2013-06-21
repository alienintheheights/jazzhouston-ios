//
//  InstrumentTableViewCell.m
//  JazzHouston
//
//  Created by Mr. Shoe on 6/20/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "InstrumentTableViewCell.h"

@implementation InstrumentTableViewCell

@synthesize instrumentName = _instrumentName;

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


-(void) setCellData:(NSDictionary *) thisInstrument {
	NSDictionary *instData = [thisInstrument objectForKey:@"instrument"];
	self.instrumentName.text = [instData objectForKey:@"instrument_name"];

}

/**
 For use by the Segue
 **/
-(int)fetchInstId:(NSDictionary *) thisInstrument {
	NSDictionary *instData = [thisInstrument objectForKey:@"instrument"];
	return [[instData objectForKey:@"instrument_id"] intValue];
}

@end
