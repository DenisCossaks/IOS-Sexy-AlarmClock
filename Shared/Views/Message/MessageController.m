    //
//  MessageController.m
//  WakeMe
//
//  Created by OCH-Mac on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageController.h"
#import "AlarmInfo.h"

@implementation MessageController

@synthesize delegate, m_bShow;

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
	UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"Back%d.jpg", m_alarmInfo.alarmImage]];
	m_imgBack.image = image;
	
	CGRect rect = [self.view bounds];
	CGFloat height = (rect.size.width / image.size.width) * image.size.height;
	m_imgBack.frame = CGRectMake(0, (rect.size.height - height) / 2.0, rect.size.width, height);
	m_labelMessage.text = m_alarmInfo.strMessage;
	if(m_alarmInfo.snoozeTime == 0) {
		m_btnStop.frame = CGRectMake(102, 403, 120, 37);
		m_btnSnooze.hidden = YES;
	}
	else {
		m_btnStop.frame = CGRectMake(36, 403, 120, 37);
		m_btnSnooze.hidden = NO;
	}
}

- (IBAction)actionStop:(id)sender {
	[delegate stopAlarmDelegate:self];
}

- (IBAction)actionSnooze:(id)sender {
	[delegate snoozeAlarmDelegate:self];
}

- (void)showMessage:(AlarmInfo*)info {
	m_alarmInfo = info;
	m_bShow = YES;
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
    [super dealloc];
}


@end
