//
//  ShowsViewController.m
//  SocialApp
//
//  Created by Andrew Lienhard on 3/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "EventIndexTableViewController.h"
#import "EventListTableViewCell.h"
#import "EventDetailViewController.h"
#import "EventListing.h"
#import "Venue.h"



@implementation EventIndexTableViewController


- (id)initWithCoder:(NSCoder *)aDecoder
{
	NSLog(@"initWithCoder");
	if ((self = [super initWithCoder:aDecoder])) {
		
		self.shows = [[NSMutableArray alloc] init];
    }
	
    return self;
}

- (void)viewDidLoad
{
	
	[super viewDidLoad];

	// add pull-to-refresh control
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(loadInBackground) forControlEvents:UIControlEventValueChanged];

	refreshControl.tintColor = [UIColor magentaColor];
	self.refreshControl = refreshControl;	
}

-(void)loadInBackground {
	
	[ApplicationDelegate.jazzHoustonEngine fetchShowsToday:^(NSMutableArray* jsonResponse) {
		self.shows = [[NSMutableArray alloc] init]; // let ARC clean it up
		[self.shows addObjectsFromArray:jsonResponse];
		[self.tableView reloadData];
		[self.refreshControl endRefreshing];
	}
    errorHandler:^(NSError* error) {
	  //TODO: implement
    }];

}

/**
 Run at start-up or with the back button, so adjust responses accordingly
 **/
- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self loadInBackground];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"starting cellForRowAtIndexPath");
	static NSString *cellIdentifier = @"CalendarTableView";
	EventListTableViewCell *cell;
	cell = (EventListTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[EventListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	if ([self.shows count]==0)
		return cell;
	NSDictionary *event = (self.shows)[indexPath.row];
    [cell setCellData:event];
	
	return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.shows count];
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.2];
        cell.backgroundColor = altCellColor;
    }
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// sender is the tableview cell
	NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
	
	if ([segue.identifier isEqualToString:@"EventDetails"])
	{
		EventDetailViewController *eventDetailVC = [segue destinationViewController];
		int eventId = [sender fetchId:(self.shows)[indexPath.row]];
		NSLog(@"I am preparing for segue with %d", eventId);
		eventDetailVC.eventId = eventId;
	}
}

//TODO: add sections by day of week

@end
