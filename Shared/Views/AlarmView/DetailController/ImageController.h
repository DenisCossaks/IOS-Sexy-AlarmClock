//
//  ImageController.h
//  WakeMe
//
//  Created by OCH-Mac on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>


@protocol ImageControllerDelegate;

@class ImageSelectView;
@interface ImageController : UIViewController {
	id <ImageControllerDelegate>	delegate;
	NSUInteger		m_nSelIndex;
	IBOutlet UIScrollView*			m_scrollViewImageSel;
	ImageSelectView*				m_imageSelView;
    
}
//@property(nonatomic,retain)RevMobBanner *banner;

@property (nonatomic, retain) id <ImageControllerDelegate> delegate;
@property (nonatomic) NSUInteger	selIndex;

@end

@protocol ImageControllerDelegate
- (void)updateImageDelegate:(ImageController*)controller Value:(NSUInteger)value;
@end
