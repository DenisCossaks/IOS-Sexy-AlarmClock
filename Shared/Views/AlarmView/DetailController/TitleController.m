    //
//  TitleController.m
//  WakeMe
//
//  Created by OCH-Mac on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TitleController.h"
#import "AlarmSettingController.h"
#import <QuartzCore/QuartzCore.h>


@implementation TitleController

@synthesize delegate, textFiled, text;

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
    
    self.textFiled.layer.borderColor=[[UIColor whiteColor] CGColor];
    self.textFiled.layer.borderWidth=1.0;
    
    
	self.title = @"Alarm Subject";
	[self.textFiled setText:text];
    
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
    
    NSString* string = [self.textFiled.text copy];
	[delegate updateTitleDelegate:self String:string];
    
//    [self.banner hideAd];
    
}

- (void)setText:(NSString*)str {
	text = [str copy];
	[self.textFiled setText:str];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

//- (id)init {
//	self = [super init];
//	self.title = @"Alarm Subject";
//	//	self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel 
//	//																						   target:self action:@selector(cancel:)] autorelease];
//	CGRect rect = [[UIScreen mainScreen] bounds];
//	self.view = [[UIView alloc] initWithFrame:rect];
//	self.view.backgroundColor = [UIColor whiteColor];
//	textFiled = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, 280, 31)];
//	[self.view addSubview:textFiled];
//	return self;
//}

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
	[textFiled release];
    [super dealloc];
}

@end
