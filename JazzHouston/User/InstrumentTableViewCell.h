//
//  InstrumentTableViewCell.h
//  JazzHouston
//
//  Created by Mr. Shoe on 6/20/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InstrumentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *instrumentName;


-(void) setCellData:(NSDictionary *) thisInstrument;
-(int)fetchInstId:(NSDictionary *) thisInstrument;

@end
