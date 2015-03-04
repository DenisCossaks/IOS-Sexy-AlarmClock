    //
//  SoundController.m
//  WakeMe
//
//  Created by OCH-Mac on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoundController.h"
#import "SoundTableViewCell.h"
#import "AlarmInfo.h"
#import "GameUtils.h"

@implementation SoundController

@synthesize delegate, selIndex = m_nSelIndex, m_tableView, m_btnPodSel;

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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

//    self.banner = [[RevMobAds session] banner];
//    [self.banner loadAd];
//    [self.banner showAd];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

	[g_GameUtils stopSoundEffect];
	[delegate updateSoundDelegate:self Value:m_nSelIndex];
    
//    [self.banner hideAd];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"Alarm Voice";
//	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit 
	//																							target:self action:@selector(actionEdit)] autorelease];	
	NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:m_nSelIndex inSection:0];
	[m_tableView selectRowAtIndexPath:selectionIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];

   
}


- (void)actionEdit {
	if(!m_tableView.editing) {
		self.navigationItem.rightBarButtonItem.title = @"Done";
		[m_tableView setEditing:YES animated:YES];
	}
	else {
		self.navigationItem.rightBarButtonItem.title = @"Edit";
		[m_tableView setEditing:NO animated:YES];
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
	[m_tableView release];
	[m_btnPodSel release];
    [super dealloc];
}

- (void)setSelIndex:(NSUInteger)sel {
	NSIndexPath *selectionIndexPath = [NSIndexPath indexPathForRow:sel inSection:0];
	[m_tableView selectRowAtIndexPath:selectionIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
	m_nSelIndex = sel;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return DEFAULT_SOUNDCOUNT;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SoundTableCell";
	SoundTableViewCell* cell = (SoundTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SoundTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
	cell.index = indexPath.row;
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	m_nSelIndex = indexPath.row;
}

@end
