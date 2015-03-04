    //
//  AlarmViewController.m
//  WakeMe
//
//  Created by OCH-Mac on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmViewController.h"
#import "GameUtils.h"
#import "AlarmInfoTableViewCell.h"
#import "AlarmInfo.h"
#import "AppDelegate.h"

@interface AlarmViewController (PrivateMethods)
- (void)addAlarmInfo;
- (void)configureCell:(AlarmInfoTableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation AlarmViewController


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
//	m_tableView.allowsSelectionDuringEditing = YES;
	m_nIndexAlarmInfo = 0;

    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
//    self.banner = [[RevMobAds session] banner];
//    [self.banner loadAd];
//    [self.banner showAd];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
//    [self.banner hideAd];
}


- (IBAction)actionBack {

	[mainViewController flipShowSetting:self.view];
    
}

- (void)actionAfterDelay {
//	mainViewController.m_bShow = YES;
}

- (IBAction)actionSetting:(id)sender {
	switch (m_segSettings.selectedSegmentIndex) {
		case 0:
			if(!m_tableView.editing) {
				[m_segSettings setTitle:@"Done" forSegmentAtIndex:0];
				[m_tableView setEditing:YES animated:YES];
			}
			else {
				[m_segSettings setTitle:@"Edit" forSegmentAtIndex:0];
				[m_tableView setEditing:NO animated:YES];
			}
			break;
		case 1:
			[self addAlarmInfo];
			break;
		default:
			break;
	}
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
//    [settingController release];
    [super dealloc];
}

#pragma mark -
#pragma mark Adding a AlarmInfo

- (void)addAlarmInfo {
//	self.settingController.m_alarmInfo = (AlarmInfo*)[NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:addingContext];
	m_nIndexAlarmInfo = [g_GameUtils.dataArray count];
	AlarmInfo* info = [[AlarmInfo alloc] init];
	AlarmSettingController* addViewController = [[AlarmSettingController alloc] initWithNibName:@"AlarmSetting_iPhone" bundle:nil];
	[addViewController setAlarmInfo:info];
	addViewController.delegate = self;

	AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addViewController];
    [appDelegate.navigationController presentViewController:navController animated:YES completion:nil];
	
	[info release];
	[addViewController release];
	[navController release];
}

#pragma mark - AlarmSettingController delegete
#pragma mark get a AlarmInfo

- (void)AlarmSettingController:(AlarmSettingController*)controller didFinishWithSave:(BOOL)save {
	if (save) {
		if(controller.alarmInfo != nil) {
			if(m_nIndexAlarmInfo >= [g_GameUtils.dataArray count]) {
				[g_GameUtils addAlarmInfo:controller.alarmInfo];
			}
			else {
				[g_GameUtils replaceAlarmInfo:m_nIndexAlarmInfo Info:controller.alarmInfo];
			}
		}
		[m_tableView reloadData];
	}
	
	if(m_tableView.editing) {
		[m_segSettings setTitle:@"Edit" forSegmentAtIndex:0];
		[m_tableView setEditing:NO];
	}
	// Dismiss the modal view to return to the main list
	AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = [g_GameUtils.dataArray count];
    
    NSLog(@"alarm setting : count = %d", count);
    
	return count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"AlarmInfoTableViewCell";
    
    AlarmInfoTableViewCell* cell = (AlarmInfoTableViewCell*)[m_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[AlarmInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell.
	[self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(AlarmInfoTableViewCell*)cell atIndexPath:(NSIndexPath *)indexPath {
    // Configure the cell to show the book's title
	AlarmInfo* info = [g_GameUtils getAlarmInfo:indexPath.row];
	[cell setAlarmInfo:info];
	cell.index = indexPath.row;
	[info release];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[g_GameUtils removeAlarmInfo:indexPath.row];
		[m_tableView reloadData];
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
	// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
	}   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 65;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(m_tableView.editing) {
		m_nIndexAlarmInfo = indexPath.row;
		AlarmSettingController* addViewController = [[AlarmSettingController alloc] initWithNibName:@"AlarmSetting_iPhone" bundle:nil];
		[addViewController setAlarmInfo:[g_GameUtils getAlarmInfo:indexPath.row]];
		addViewController.delegate = self;
		
		AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
		
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addViewController];
        [appDelegate.navigationController presentViewController:navController animated:YES completion:nil];
		[addViewController release];
		[navController release];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
// Return NO if you do not want the specified item to be editable.
	return NO;
}
*/

@end
