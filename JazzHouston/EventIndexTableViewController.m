//
//  ShowsViewController.m
//  SocialApp
//
//  Created by Andrew Lienhard on 3/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "EventIndexTableViewController.h"
#import "EventsDataController.h"
#import "EventListTableViewCell.h"
#import "EventDetailViewController.h"
#import "EventListing.h"
#import "Venue.h"


@interface EventIndexTableViewController ()

@property (nonatomic, strong) EventsDataController *showsDataController;

@end


@implementation EventIndexTableViewController

@synthesize showsDataController = _showsDataController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	NSLog(@"initWithCoder");
	if ((self = [super initWithCoder:aDecoder])) {
		
        self.showsDataController = [[EventsDataController alloc] init];
    }
	
    return self;
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
	
	// TODO: handle case where returned data is empty (i.e., erase the "loading data" message)
	if ([self.showsDataController numberOfShows]==0)
	{
		return cell;
		
	}
	
	// extract data for this row
	EventListing *eventListing = [self.showsDataController getEventByRow:indexPath.row];
	Venue *currentVenue = eventListing.venue;
	cell.venueLabel.text = currentVenue.title;
	
	// draw text into row
	cell.showLabel.text = eventListing.performer;
	cell.startTimeLabel.text = eventListing.startTime;
	
	//NSLog(@"Event Listing %@, %@, %@", eventListing.performer, eventListing.startTime, eventListing.venue.title );
	if (eventListing.typeOfEvent == 1)
	{
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
		[dateFormat setDateFormat:@"EEEE"];
		NSString *dateString = [dateFormat stringFromDate:eventListing.showDate];
		cell.dateLabel.text = dateString;
	} else {		
		cell.dateLabel.text = eventListing.dayOfWeek;			
	}
	
		
	
	return cell;
}


- (void)viewDidLoad
{
	NSLog(@"starting Shows viewDidLoad");
    [super viewDidLoad];
	
	
	// add pull-to-refresh control
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
										init];
	[refreshControl addTarget:self action:@selector(loadInBackground) forControlEvents:UIControlEventValueChanged];
    
	refreshControl.tintColor = [UIColor magentaColor];
	self.refreshControl = refreshControl;
	[self.view setBackgroundColor:[UIColor whiteColor]];
	[self.tableView setHidden:YES];
	[self loadInBackground];
	
}

- (void)loadInBackground
{
	
	// The Beauty of THREADING!!
	dispatch_queue_t downloadQueue = dispatch_queue_create("jazzhouston events", NULL);
	dispatch_async(downloadQueue, ^{
		[self.showsDataController loadRemoteJSONShowData];
		dispatch_async(dispatch_get_main_queue(), ^{
			
			[self.tableView setHidden:NO];
			[self.tableView reloadData];
			[self.refreshControl endRefreshing];
		});
	});
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	int rows = [self.showsDataController numberOfShows];
	return (rows > 0) ?  rows : 1; // faulty logic, rows = 0 too
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
	NSLog(@"I am preparing for segue with %@", indexPath);
	if ([segue.identifier isEqualToString:@"EventDetails"])
	{
		EventListing *eventListing = [self.showsDataController getEventByRow:indexPath.row];
		EventDetailViewController *eventDetailVC = [segue destinationViewController];
		eventDetailVC.eventId = eventListing.eventId;
		eventDetailVC.eventListing = eventListing;
		NSLog(@"I am switching to forum Topics vc %@", eventListing.performer);
	}
}

//TODO: add sections by day of week

@end
