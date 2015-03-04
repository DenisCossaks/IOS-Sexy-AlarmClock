//
//  SettingViewController.m
//  WakeMe
//
//  Created by OCH-Mac on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"
#import "MainViewController.h"
#import "GameUtils.h"

@implementation SettingViewController

enum {
    kTableItem24Hour		= 0,      // rows are kServerValidationXxx
    kTableItemDisplayDate,        // rows are NSURLCredentialPersistence
    kTableItemCancelStandby,
    kTableItemCount
};

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    self.banner = [[RevMobAds session] banner];
//    [self.banner loadAd];
//    [self.banner showAd];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.banner hideAd];
}


- (IBAction)actionDone {
	[mainViewController flipShowSetting:self.view];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return kTableItemCount;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
				case kTableItem24Hour:
                    cell.textLabel.text = @"24Hour Clock Mode";
					cell.accessoryType = g_GameUtils.m_bHour24 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
					break;
				case kTableItemDisplayDate:
                    cell.textLabel.text = @"Display Date";
					cell.accessoryType = g_GameUtils.m_bDisplayDate ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
					break;
				case kTableItemCancelStandby:
                    cell.textLabel.text = @"Cancel Standby Mode";
					cell.accessoryType = g_GameUtils.m_bCancelStandby ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
					break;
				default:
					break;
			}
			break;
		default:
			break;
	}
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *   cellToClear = nil;
    UITableViewCell *   cellToSet = nil;
	
	BOOL bSelect = NO;
	switch (indexPath.row) {
		case kTableItem24Hour:
			bSelect = g_GameUtils.m_bHour24;
			g_GameUtils.m_bHour24 = !bSelect;
			break;
		case kTableItemDisplayDate:
			bSelect = g_GameUtils.m_bDisplayDate;
			g_GameUtils.m_bDisplayDate = !bSelect;
			break;
		case kTableItemCancelStandby:
			bSelect = g_GameUtils.m_bCancelStandby;
			g_GameUtils.m_bCancelStandby = !bSelect;
			[[UIApplication sharedApplication] setIdleTimerDisabled:g_GameUtils.m_bCancelStandby];
			break;
		default:
			break;
	}
	if(bSelect)
		cellToClear = [tableView cellForRowAtIndexPath:indexPath];
	else
		cellToSet   = [tableView cellForRowAtIndexPath:indexPath];
	
    if (cellToClear != nil) {
        cellToClear.accessoryType = UITableViewCellAccessoryNone;
    }
    if (cellToSet != nil) {
        cellToSet.accessoryType   = UITableViewCellAccessoryCheckmark;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

