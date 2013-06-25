//
//  EventDetailViewController.h
//  SocialApp
//
//  Created by Mr. Shoe on 3/20/13.
//
//

#import <UIKit/UIKit.h>
#import "JazzHoustonAppDelegate.h"

@interface EventDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *showPerformerLabel;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;

@property (weak, nonatomic) IBOutlet UITextView *showAboutText;

@property (weak, nonatomic) IBOutlet UITextView *venuePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *showDateLabel;
@property (weak, nonatomic) IBOutlet UITextView *venueAddressLabel;

@property (weak, nonatomic) IBOutlet UILabel *showTimeLabel;

@property (nonatomic) int eventId;
@end
