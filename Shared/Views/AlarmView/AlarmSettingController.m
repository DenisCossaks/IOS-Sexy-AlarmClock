    //
//  AlarmSettingController.m
//  WakeMe
//
//  Created by OCH-Mac on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmSettingController.h"
#import "AppDelegate.h"
#import "AlarmInfo.h"
#import "SettingInfoTableViewCell.h"

@interface AlarmSettingController (PrivateMethods)
- (void)configureCell:(SettingInfoTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation AlarmSettingController

enum {
    kTableCellMessage		= 0,
    kTableCellSnoozeTime,
    kTableCellPeriod,
    kTableCellSound,
    kTableCellImage,
	kTableCellCount,
};

@synthesize delegate;
@synthesize m_tableView;
@synthesize m_pickerView;
@synthesize alarmInfo = m_alarmInfo;
//@synthesize banner;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Alarm Setting";
	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                           target:self action:@selector(actionCancel:)] autorelease];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
																							target:self action:@selector(actionSave:)] autorelease];
	[m_pickerView selectRow:m_alarmInfo.alarmHour inComponent:0 animated: NO];
	[m_pickerView selectRow:m_alarmInfo.alarmMin inComponent:1 animated: NO];
    
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	[m_tableView reloadData];
    
    
//    self.banner = [[RevMobAds session] banner];
//    [self.banner loadAd];
//    [self.banner showAd];

}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [self.banner hideAd];
}
- (void)setAlarmInfo:(AlarmInfo*)newAlarmInfo {
	if (newAlarmInfo != m_alarmInfo) {
        [m_alarmInfo release];
        m_alarmInfo = [newAlarmInfo retain];
	}
	[m_pickerView selectRow:m_alarmInfo.alarmHour inComponent:0 animated: NO];
	[m_pickerView selectRow:m_alarmInfo.alarmMin inComponent:1 animated: NO];
	[m_tableView reloadData];
}

- (IBAction)actionSave:(id)sender {
	m_alarmInfo.alarmHour = [m_pickerView selectedRowInComponent:0];
	m_alarmInfo.alarmMin = [m_pickerView selectedRowInComponent:1];
    
	[delegate AlarmSettingController:self didFinishWithSave:YES];
//	[self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)actionCancel:(id)sender {
	[delegate AlarmSettingController:self didFinishWithSave:NO];
//	[self.navigationController dismissModalViewControllerAnimated:YES];
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
    [m_alarmInfo release];
    [super dealloc];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return kTableCellCount;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SettingInfoTableViewCell";
    
    SettingInfoTableViewCell* cell = (SettingInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		if(indexPath.row < 4)
			cell = [[[SettingInfoTableViewCell alloc] initWithStyle:SettingInfoTableCellTextType reuseIdentifier:CellIdentifier] autorelease];
		else
			cell = [[[SettingInfoTableViewCell alloc] initWithStyle:SettingInfoTableCellImageType reuseIdentifier:CellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell.
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.row) {
		case kTableCellMessage:
			return 31;
			break;
		case kTableCellSnoozeTime:
			return 31;
			break;
		case kTableCellPeriod:
			return 31;
			break;
		case kTableCellSound:
			return 31;
			break;
		case kTableCellImage:
			return 57;
			break;
		default:
			break;
	}
	return 44;
}

- (void)configureCell:(SettingInfoTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	
    // Configure the cell to show the book's title
	switch (indexPath.row) {
		case kTableCellMessage:
			[cell setCellText:@"Alarm Subject" Content:m_alarmInfo.strMessage];
			break;
		case kTableCellSnoozeTime:
			[cell setCellText:@"Snooze Function" Content:m_alarmInfo.strSnoozeTime];
			break;
		case kTableCellPeriod:
			[cell setCellText:@"Time Period" Content:m_alarmInfo.strPeriod];
			break;
		case kTableCellSound:
			[cell setCellText:@"Alarm Voice" Content:m_alarmInfo.strSound];
			break;
		case kTableCellImage:
			[cell setCellImage:@"Alarm Picture" Image:m_alarmInfo.imageAlarm];
			break;
		default:
			break;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	UIViewController* controller;
	switch (indexPath.row) {
		case kTableCellMessage:
			controller = [[TitleController alloc] initWithNibName:@"MessageSetting_iPhone" bundle:nil];
			((TitleController*)controller).text = m_alarmInfo.strMessage;
			((TitleController*)controller).delegate = self;
			break;
		case kTableCellSnoozeTime:
			controller = [[SnoozeController alloc] initWithStyle:UITableViewStyleGrouped];
			((SnoozeController*)controller).index = m_alarmInfo.snoozeTime;
			((SnoozeController*)controller).delegate = self;
			break;
		case kTableCellPeriod:
			controller = [[PeriodController alloc] initWithStyle:UITableViewStyleGrouped];
			((PeriodController*)controller).periodValue = m_alarmInfo.period;
			((PeriodController*)controller).delegate = self;
			break;
		case kTableCellSound:
			controller = [[SoundController alloc] initWithNibName:@"SoundSetting_iPhone" bundle:nil];
			((SoundController*)controller).selIndex = m_alarmInfo.sound;
			((SoundController*)controller).delegate = self;
			break;
		case kTableCellImage:
			controller = [[ImageController alloc] initWithNibName:@"ImageSetting_iPhone" bundle:nil];
			((ImageController*)controller).selIndex = m_alarmInfo.alarmImage;
			((ImageController*)controller).delegate = self;
			break;
		default:
			break;
	}
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
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

#pragma mark UIPickerViewDelegate & UIPickerViewDataSource methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSInteger numComps = 0;
	switch(component)
	{
		case 0:
			numComps = 24;
			break;
		case 1:
			numComps = 60;
			break;
		default:
			break;
	}
	return numComps;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 70;
}

#define kHourTag		1
#define kMinutesTag		2

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UILabel *label;
	switch (component)
	{
		case 0:
			if(view.tag != kHourTag)
			{
				CGRect frame = CGRectZero;
				frame.size = [pickerView rowSizeForComponent:component];
				frame = CGRectInset(frame, 4.0, 4.0);
				view = [[[UILabel alloc] initWithFrame:frame] autorelease];
				view.tag = kHourTag;
				view.userInteractionEnabled = NO;
				view.backgroundColor = [UIColor clearColor];
			}
			label = (UILabel*)view;
			label.textColor = [UIColor blackColor];
			label.text = [NSString stringWithFormat:@"%d", row];
			label.font = [UIFont boldSystemFontOfSize:24.0];
			label.textAlignment = NSTextAlignmentRight;
			break;
		case 1:
			if(view.tag != kMinutesTag)
			{
				CGRect frame = CGRectZero;
				frame.size = [pickerView rowSizeForComponent:component];
				frame = CGRectInset(frame, 4.0, 4.0);
				view = [[[UILabel alloc] initWithFrame:frame] autorelease];
				view.tag = kMinutesTag;
				view.userInteractionEnabled = NO;
				view.backgroundColor = [UIColor clearColor];
			}
			label = (UILabel*)view;
			label.textColor = [UIColor blackColor];
			label.text = [NSString stringWithFormat:@"%02d", row];
			label.font = [UIFont boldSystemFontOfSize:24.0];
			label.textAlignment = NSTextAlignmentCenter;
			break;
		default:
			break;
	}
	return view;
}

#pragma mark - Controller delegete
#pragma mark get a Alarm Message
- (void)updateTitleDelegate:(TitleController*)controller String:(NSString*)string {
	m_alarmInfo.strMessage = [string copy];
}

- (void)updateSnoozeDelegate:(SnoozeController*)controller Value:(NSUInteger)value {
	m_alarmInfo.snoozeTime = value;
}

- (void)updatePeriodDelegate:(PeriodController*)controller Value:(NSUInteger)value {
	m_alarmInfo.period = value;
}

- (void)updateSoundDelegate:(SoundController*)controller Value:(NSUInteger)value {
	m_alarmInfo.sound = value;
}

- (void)updateImageDelegate:(ImageController*)controller Value:(NSUInteger)value {
	m_alarmInfo.alarmImage = value;
}

@end
