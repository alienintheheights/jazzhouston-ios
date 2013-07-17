//
//  SocialAppViewController.m
//  SocialApp
//
//  Created by Andrew Lienhard on 3/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "JazzHoustonTableViewController.h"

@interface JazzHoustonTableViewController ()

@end

@implementation JazzHoustonTableViewController


-(UIActivityIndicatorView *)animate {
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
	spinner.center = CGPointMake(160, 60);
	spinner.hidesWhenStopped = YES;
	[self.view addSubview:spinner];
	[spinner startAnimating];
	
	return spinner;
	
}

-(void)endLoading:(UIActivityIndicatorView *)spinner {
	[self.refreshControl endRefreshing];
	[spinner stopAnimating];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
