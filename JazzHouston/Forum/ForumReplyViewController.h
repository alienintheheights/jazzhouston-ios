//
//  ForumReplyViewController.h
//  JazzHouston
//
//  Created by Mr. Shoe on 6/23/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumReplyViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) NSNumber *topicId;
@property (strong, nonatomic) IBOutlet UILabel *topicName;

@property (strong, nonatomic) UITextView *messageBody;

@property (strong, nonatomic) IBOutlet UIButton *replyButton;

- (IBAction)replyToPost:(id)sender;
- (void)textViewDidBeginEditing:(UITextView	*)textView;


@end
