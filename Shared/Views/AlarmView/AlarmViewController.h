//
//  AlarmViewController.h
//  WakeMe
//Core Data Programming Guide
//  Created by OCH-Mac on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AlarmSettingController.h"
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>

@class MainViewController;

@interface AlarmViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AlarmSettingControllerDelegate> {
	IBOutlet MainViewController*	mainViewController;
	
	IBOutlet UISegmentedControl*	m_segSettings;
	IBOutlet UITableView*			m_tableView;
	
//	AlarmSettingController*			settingController;

	NSUInteger	m_nIndexAlarmInfo;
}

//@property(nonatomic,retain)RevMobBanner *banner;

- (IBAction)actionBack;
- (IBAction)actionSetting:(id)sender;

@end
