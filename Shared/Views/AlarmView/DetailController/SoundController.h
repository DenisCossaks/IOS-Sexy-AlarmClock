//
//  SoundController.h
//  WakeMe
//
//  Created by OCH-Mac on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>

@protocol SoundControllerDelegate;

@interface SoundController : UIViewController {
	id <SoundControllerDelegate>	delegate;
	NSUInteger		m_nSelIndex;
	UITableView*	m_tableView;
	UIButton*		m_btnPodSel;
    
}
//@property(nonatomic,retain)RevMobBanner *banner;


@property (nonatomic, retain) id <SoundControllerDelegate> delegate;
@property (nonatomic) NSUInteger	selIndex;
@property (nonatomic, retain) IBOutlet UITableView*		m_tableView;
@property (nonatomic, retain) IBOutlet UIButton*		m_btnPodSel;

@end

@protocol SoundControllerDelegate
- (void)updateSoundDelegate:(SoundController*)controller Value:(NSUInteger)value;
@end
