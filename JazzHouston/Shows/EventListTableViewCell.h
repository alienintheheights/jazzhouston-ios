//
//  EventListTableViewCell.h
//  SocialApp
//
//  Created by Mr. Shoe on 3/18/13.
//
//

#import <UIKit/UIKit.h>

@interface EventListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

-(void) setCellData:(NSDictionary *) thisInstrument;
-(int)fetchId:(NSDictionary *)data;

@end
