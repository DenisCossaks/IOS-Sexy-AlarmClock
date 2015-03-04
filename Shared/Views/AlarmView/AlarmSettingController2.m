    //
//  AlarmSettingController.m
//  WakeMe
//
//  Created by OCH-Mac on 2/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmSettingController.h"
#import "AlarmInfo.h"


@implementation AlarmSettingController

@synthesize delegate;
@synthesize alarmInfo, editSubjet, switchSnooze, btnSound, pickTime;

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
	editSubjet.text = @"My ringtone";
}

- (IBAction)actionSave:(id)sender {
	[delegate AlarmSettingController:self didFinishWithSave:YES];
}

- (IBAction)actionSound:(id)sender {
	
}

- (void)setAlarmInfo:(AlarmInfo*)newAlarmInfo {
	if (newAlarmInfo != alarmInfo) {
        [alarmInfo release];
        alarmInfo = [newAlarmInfo retain];
	}
	//addOOO
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	[alarmInfo release];
	[editSubjet release];
	[switchSnooze release];
	[btnSound release];
	[pickTime release];
    [super dealloc];
}


@end
