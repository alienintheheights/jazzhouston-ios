//
//  MusicianViewController.m
//  JazzHouston
//
//  Created by Mr. Shoe on 3/22/13.
//
//

#import "MusicianViewController.h"
#import "MusicianTableViewCell.h"

#define PER_PAGE 10

@interface MusicianViewController ()

@property (nonatomic) int pageNumber;

@end

@implementation MusicianViewController


@synthesize pageNumber = _pageNumber;
@synthesize instId = _instId;



- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
        self.pageNumber = 1;
		self.musicians = [[NSMutableArray alloc] init];
    }
    return self;
}

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


- (void)refreshSelector:(UIButton*)sender{
	// reset data and start from the top
	[self loadInBackground:YES ];
}

/**
 Launches MKNetworkKit delegate
 Supports forced reload to skip cache and reset pageNumber
 Also starts and stops spinner animation
 **/
- (void)loadInBackground:(BOOL)forceReload
{
	// TODO: combine w/ topictableviewC into a method--perhaps a common parent Controller too?
	UIActivityIndicatorView *spinner = [self animate];
	
    [ApplicationDelegate.musicianEngine
			 fetchRemoteMusicians:self.instId
			 forPageNumber:(forceReload)? 1: self.pageNumber
			 withForceReload:forceReload
			 completionHandler:^(NSMutableArray* jsonMusicians) {
				 // forceReload => re-init the array
				 if (forceReload) {
					 self.musicians = [[NSMutableArray alloc] init]; // let ARC clean it up
					 if (self.pageNumber>1) self.pageNumber = 1; // reset
				 }
				 // add (or append) objects
				 [self.musicians addObjectsFromArray:jsonMusicians];
				 [self.tableView reloadData];
				 // enable next page
				 self.pageNumber++;
				 [self endLoading:spinner];
				 
			 }
			 errorHandler:^(NSError* error) {
				 //TODO: implement
			 }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self loadInBackground:NO];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *phoneString = [NSString stringWithFormat:@"tel:#%@", [self.musicians objectAtIndex:indexPath.row]];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneString]];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"MusicianListingTableViewCell";
	
	 MusicianTableViewCell *cell;
	cell = (MusicianTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[MusicianTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	NSDictionary *thisPlayer = (self.musicians)[indexPath.row];
	
    [cell setCellData:thisPlayer];
	return cell;
	 
}

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [self.musicians count];
}



@end
