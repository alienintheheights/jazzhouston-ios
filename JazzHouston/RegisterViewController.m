//
//  RegisterViewController.m
//  JazzHouston
//
//  Created by Mr. Shoe on 6/26/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

@synthesize firstNameField = _firstNameField;
@synthesize lastNameField = _lastNameField;
@synthesize usernameField = _usernameField;
@synthesize emailField = _emailField;
@synthesize passwordField = _passwordField;
@synthesize confirmPasswordField = _confirmPasswordField;
@synthesize signupButton = _signupButton;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signup:(id)sender {
	
}
@end
