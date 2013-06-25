//
//  ForumReplyViewController.m
//  JazzHouston
//
//  Created by Mr. Shoe on 6/23/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "ForumReplyViewController.h"
#import "JazzHoustonAppDelegate.h"

@interface ForumReplyViewController ()

@end

@implementation ForumReplyViewController

@synthesize messageBody = _messageBody;
@synthesize topicId = _topicId;
@synthesize topicName = _topicName;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
		self.messageBody.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[self.replyButton setTitle:@"Post" forState:UIControlStateNormal];
	self.replyButton.showsTouchWhenHighlighted = YES;
	self.replyButton.frame = CGRectMake(0.0, 0.0, 50, 50);
	
	[self.replyButton addTarget:self action:@selector(replyToPost:) forControlEvents:UIControlEventTouchUpInside];
	
	UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.replyButton];
	self.navigationItem.rightBarButtonItem = rightButton;

	 /*--
     * Create the UITextView Programmatically
     * Set the delegate property to self
     * Add the UITextView to the view
     * Optional - Add the UITextView to the .xib file instead
     --*/
    
    CGRect textViewFrame = CGRectMake(20.0f, 50.0f, 280.0f, 124.0f);
	self.messageBody = [[UITextView alloc] initWithFrame:textViewFrame];
	self.messageBody.returnKeyType = UIReturnKeyDone;
	self.messageBody.delegate = self;
	self.messageBody.textColor = [UIColor blackColor];
	self.messageBody.text = @"type your brilliant thoughts";
    [self.view addSubview: self.messageBody];
	
	self.topicName.text = [NSString stringWithFormat:@"Replying to %@", _topicId];
    [self.replyButton setEnabled:NO];
	[self.replyButton setHighlighted:NO];
}


-(IBAction) replyToPost:(id) sender {
	
	[self.replyButton setEnabled:NO];
	NSDictionary *formFields = [[NSMutableDictionary alloc] init];
	[formFields setValue:self.messageBody.text forKey:@"post[message_text]"];
	[formFields setValue:self.topicId forKey:@"post[thread_id]"];
	NSLog(@"About to post a comment for thread id %@", self.topicId);
	
	[ApplicationDelegate.jazzHoustonEngine replyToTopic:formFields
									completionHandler:^(NSMutableArray* jsonForumPosts) {
		 
										self.messageBody.backgroundColor = [UIColor redColor];
										[self.replyButton setEnabled:NO];
										[self.replyButton setHighlighted:NO];

										[[[UIAlertView alloc] initWithTitle:@"Done!"
																	message:@"Your reply has been posted"
																   delegate:nil
														  cancelButtonTitle:@"OK"
														  otherButtonTitles:nil] show];
										[self.navigationController popViewControllerAnimated:YES];
	 }
	 errorHandler:^(NSError* error) {
		 //TODO: implement
	 }
	 ];
	
	
}
#pragma mark -
#pragma mark UITextViewDelegate Methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    /*--
     * This method is called just before the textView becomes active
     * Return YES to let the textView become the First Responder otherwise return NO
     * Use this method to give the textView a green colored background
     --*/
    
    //NSLog(@"textViewShouldBeginEditing:");
	self.messageBody.text =@"";
	self.messageBody.textColor = [UIColor colorWithRed:0x33/255.0 green:0x33/255.0 blue:0x33/255.0 alpha:1.0];
	
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    /*--
     * This method is called when the textView becomes active, or is the First Responder
     --*/
   
    textView.backgroundColor = [UIColor colorWithRed:0xf5/255.0 green:0xf5/255.0 blue:0xf5/255.0 alpha:1.0];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    /*--
     * This method is called just before the textView is no longer active
     * Return YES to let the textView resign first responder status, otherwise return NO
     * Use this method to turn the background color back to white
     --*/
    
	// NSLog(@"textViewShouldEndEditing:");
    textView.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    /*--
     * This method is called when the textView is no longer active
     --*/
    
	// NSLog(@"textViewDidEndEditing:");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    //NSLog(@"textView.text.length + text.length-- %i",textView.text.length + text.length);
    
    /*--
     * This method is called just before text in the textView is displayed
     * This is a good place to disallow certain characters
     * Limit textView to 140 characters
     * Resign keypad if done button pressed comparing the incoming text against the newlineCharacterSet
     * Return YES to update the textView otherwise return NO
     --*/
    
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
	
    if (!self.replyButton.isEnabled &&  textView.text.length>0) {
		[self.replyButton setEnabled:YES];
		[self.replyButton setHighlighted:YES];
	}
	
    if (textView.text.length + text.length == 0) {
        [self.replyButton setEnabled:NO];
		[self.replyButton setHighlighted:NO];
    }
    else if (location != NSNotFound){ //Did not find any newline characters
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
	
}

- (void)textViewDidChange:(UITextView *)textView
{
	// NSLog(@"textViewDidChange:");
    //This method is called when the user makes a change to the text in the textview
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    //NSLog(@"textViewDidChangeSelection:------->>");
    //This method is called when a selection of text is made or changed
}

#pragma mark -
#pragma mark UIResponder Override
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"touchesBegan:withEvent:");
    
    /*--
     * Override UIResponder touchesBegan:withEvent: to resign the textView when the user taps the background
     * Use fast enumeration to go through the subview property of UIView
     * Any object that is the current first repsonder will resign that status
     * Make a call to super to take care of any unknown behavior that touchesBegan:withEvent: needs to do behind the scenes
     --*/
    
    for (UITextView *textView in self.view.subviews) {
        if ([textView isFirstResponder]) {
            [textView resignFirstResponder];
        }
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
