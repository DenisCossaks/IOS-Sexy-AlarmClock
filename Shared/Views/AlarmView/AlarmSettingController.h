//
//  AlarmSettingController.h
//  WakeMe
//
//  Created by OCH-Mac on 2/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitleController.h"
#import "SnoozeController.h"
#import "PeriodController.h"
#import "SoundController.h"
#import "ImageController.h"

#import <RevMobAds/RevMobAds.h>

@protocol AlarmSettingControllerDelegate;
@class AlarmInfo;

@interface AlarmSettingController : UIViewController <UITableViewDelegate, TitleControllerDelegate, SnoozeControllerDelegate, PeriodControllerDelegate, SoundControllerDelegate, ImageControllerDelegate> {
	
    id <AlarmSettingControllerDelegate> delegate;

	AlarmInfo*		m_alarmInfo;
	
    UITableView*	m_tableView;
	UIPickerView*	m_pickerView;
    
}

//@property(nonatomic,retain)RevMobBanner *banner;
@property (nonatomic, assign) id <AlarmSettingControllerDelegate> delegate;
@property (nonatomic, retain) AlarmInfo*				alarmInfo;
@property (nonatomic, retain) IBOutlet UITableView*		m_tableView;
@property (nonatomic, retain) IBOutlet UIPickerView*	m_pickerView;

- (IBAction)actionSave:(id)sender;

@end

@protocol AlarmSettingControllerDelegate
- (void)AlarmSettingController:(AlarmSettingController*)controller didFinishWithSave:(BOOL)save;
@end
