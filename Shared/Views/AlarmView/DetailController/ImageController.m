    //
//  ImageController.m
//  WakeMe
//
//  Created by OCH-Mac on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageController.h"
#import "ImageSelectView.h"

@implementation ImageController

@synthesize delegate, selIndex = m_nSelIndex;

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

	[delegate updateImageDelegate:self Value:m_imageSelView.m_nSelect];
    
//    [self.banner hideAd];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
	m_imageSelView = [[ImageSelectView alloc] initWithFrame:m_scrollViewImageSel.bounds Type:ImageTypeOneSelect];
	m_imageSelView.m_nSelect = m_nSelIndex;
	[m_scrollViewImageSel addSubview:m_imageSelView];
	m_scrollViewImageSel.contentSize = m_imageSelView.bounds.size;

}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)setSelIndex:(NSUInteger)sel {
	m_nSelIndex = sel;
	m_imageSelView.m_nSelect = sel;
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
	[m_imageSelView release];
    [super dealloc];
}


@end
