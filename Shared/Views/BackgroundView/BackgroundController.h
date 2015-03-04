//
//  BackgroundController.h
//  WakeMe
//
//  Created by OCH-Mac on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RevMobAds/RevMobAds.h>

@class MainViewController;
@class ImageSelectView;

@interface BackgroundController : UIViewController {
	IBOutlet MainViewController*	mainViewController;
	
	IBOutlet UISlider*				m_sliderView;
	IBOutlet UILabel*				m_labelSlider;
	
	IBOutlet UILabel*				m_labelImageCount;
	IBOutlet UIScrollView*			m_scrollViewImageSel;
	ImageSelectView*				m_imageSelView;

    BOOL   _viewLoaded;
}

//@property(nonatomic,retain)RevMobBanner *banner;

- (IBAction)actionDone;
- (IBAction)actionSlider:(id)sender;

@end
