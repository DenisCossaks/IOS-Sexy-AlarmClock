    //
//  BackgroundController.m
//  WakeMe
//
//  Created by OCH-Mac on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BackgroundController.h"
#import "MainViewController.h"
#import "ImageSelectView.h"
#import "GameUtils.h"


@implementation BackgroundController
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];

    _viewLoaded = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_viewLoaded) {
        m_imageSelView = [[ImageSelectView alloc] initWithFrame:m_scrollViewImageSel.bounds Type:ImageTypeMultiSelect];
        [m_scrollViewImageSel addSubview:m_imageSelView];
        m_scrollViewImageSel.contentSize = m_imageSelView.bounds.size;
        m_sliderView.value = g_GameUtils.m_slideInterval;
        m_labelSlider.text = [NSString stringWithFormat:@"%d s", g_GameUtils.m_slideInterval];
        m_labelImageCount.text = [NSString stringWithFormat:@"%d / 14", g_nImageSelectCount];
        
        _viewLoaded = YES;
    }

    
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
	g_GameUtils.m_slideInterval = m_sliderView.value;
	int nCount = [m_imageSelView actionDone];
	if(nCount <= 1) {
		[mainViewController stopAniBackImage];
		if(nCount == 1)
			[mainViewController setImageView:g_nImageSelect[0]];
	}
	g_nImageSelectCount = nCount;
}

- (IBAction)actionSlider:(id)sender {
	int value = m_sliderView.value;
	m_labelSlider.text = [NSString stringWithFormat:@"%d s", value];
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
	[m_imageSelView release];
    [super dealloc];
}


@end
