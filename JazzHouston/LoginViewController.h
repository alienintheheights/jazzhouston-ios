//
//  LoginViewController.h
//  JazzHouston
//
//  Created by Mr. Shoe on 6/26/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JazzHoustonAppDelegate.h"

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
- (IBAction)signIn:(id)sender;

@end
