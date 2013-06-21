//
//  InstrumentViewController.m
//  JazzHouston
//
//  Created by Mr. Shoe on 6/20/13.
//  Copyright (c) 2013 Thinking Dog. All rights reserved.
//

#import "InstrumentViewController.h"
#import "MusicianViewController.h"
#import "InstrumentTableViewCell.h"

@interface InstrumentViewController ()

@end

@implementation InstrumentViewController


- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder])) {
		//
	}
	return self;
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	// sender is the tableview cell
	NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
	if ([segue.identifier isEqualToString:@"MusiciansByInstrument"]) {
		MusicianViewController *musicianVC = [segue destinationViewController];
		musicianVC.instId = [sender fetchInstId:(self.instruments)[indexPath.row]];
		NSLog(@"Seque for instId = %d",musicianVC.instId);
	}
}




- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[ApplicationDelegate.musicianEngine fetchInstruments:^(NSMutableArray* jsonInstruments) {		 
		 self.instruments = [[NSMutableArray alloc] init]; // let ARC clean it up
		 [self.instruments addObjectsFromArray:jsonInstruments];
		 [self.tableView reloadData];
	 }
	 errorHandler:^(NSError* error) {
		 //TODO: implement
	 }];
	
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.instruments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"InstrumentTableViewCell";
	InstrumentTableViewCell *cell;
	cell = (InstrumentTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (!cell) {
		cell = [[InstrumentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	NSDictionary *axe = (self.instruments)[indexPath.row];
	
    [cell setCellData:axe];
	return cell;

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
