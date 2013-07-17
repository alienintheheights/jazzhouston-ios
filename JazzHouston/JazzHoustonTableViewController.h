//
//  SocialAppViewController.h
//  SocialApp
//
//  Created by Andrew Lienhard on 3/10/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JazzHoustonTableViewController : UITableViewController

-(UIActivityIndicatorView *)animate;
-(void)endLoading:(UIActivityIndicatorView *)spinner;

@end
