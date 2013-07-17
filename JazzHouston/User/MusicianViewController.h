//
//  MusicianViewController.h
//  JazzHouston
//
//  Created by Mr. Shoe on 3/22/13.
//
//

#import <UIKit/UIKit.h>
#import "JazzHoustonAppDelegate.h"
#import "JazzHoustonTableViewController.h"	

@interface MusicianViewController : JazzHoustonTableViewController

@property (nonatomic) int instId;

@property (strong, nonatomic) NSMutableArray *musicians;


@end
