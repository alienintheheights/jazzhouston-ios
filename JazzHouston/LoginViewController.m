//
//  LoginViewController.m
//  JazzHouston
//
//  Created by Mr. Shoe on 6/26/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "LoginViewController.h"
#import "ForumIndexTableViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize usernameField = _usernameField;
@synthesize passwordField = _passwordField;
@synthesize signInButton = _signInButton;

- (IBAction)signIn:(id)sender {
	[ApplicationDelegate.jazzHoustonEngine login:self.usernameField.text
									 andPassword:self.passwordField.text
							   completionHandler:^(NSString* authToken) {
									   self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;   // your choice here from UIModalTransitionStyle
									   [self dismissViewControllerAnimated:NO completion:nil];
									}
									errorHandler:^(NSError* error) {
										NSLog(@"Error: %@", [error localizedDescription]);
										[[[UIAlertView alloc] initWithTitle:@"Error Logging In"
																	message:@"Please try again"
																   delegate:nil
														  cancelButtonTitle:@"OK"
														  otherButtonTitles:nil] show];
					}];

	
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	//NSLog(@"attempting to fetch pageNumber %d self.page =%d", pageNumber, self.pageNumber);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
