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
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
	spinner.center = CGPointMake(160, 60);
	spinner.hidesWhenStopped = YES;
	[self.view addSubview:spinner];
	[spinner startAnimating];
	

	[self.signInButton setEnabled:NO];
	[ApplicationDelegate.jazzHoustonEngine login:self.usernameField.text
									 andPassword:self.passwordField.text
							   completionHandler:^(NSString* authToken) {
								   
									   self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;   // your choice here from UIModalTransitionStyle
									   [self dismissViewControllerAnimated:NO completion:nil];
								   
										[spinner stopAnimating];
									}
									errorHandler:^(NSError* error) {
										NSLog(@"Error: %@", [error localizedDescription]);
										[[[UIAlertView alloc] initWithTitle:@"Error Logging In"
																	message:@"Please try again"
																   delegate:nil
														  cancelButtonTitle:@"OK"
														  otherButtonTitles:nil] show];
										[spinner stopAnimating];

										[self.signInButton setEnabled:YES];
										
										
					}];

	
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
