//
//  MainViewController.h
//  WakeMe
//
//  Created by OCH-Mac on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageController.h"

@class SettingViewController;
@class BackgroundController;
@class AlarmViewController;
@class AlarmInfo;

@interface MainViewController : UIViewController <UIAlertViewDelegate, MessageControllerDelegate> {
	NSTimer*				m_timerSlide;
	IBOutlet UIToolbar*		m_toolBar;

	IBOutlet UIView*		m_background;
	IBOutlet UIView*		m_timeView;
	IBOutlet UIImageView*	m_timeViewBack;
	IBOutlet UIImageView*	m_imgAlarmMark;
	IBOutlet UILabel*		m_labelHour;
	IBOutlet UILabel*		m_labelSemi;
	IBOutlet UILabel*		m_labelMin;
	IBOutlet UILabel*		m_labelAM;
	IBOutlet UILabel*		m_labelDate;
	IBOutlet UIBarItem*		m_itemSleeping;
	
	IBOutlet SettingViewController*		m_conrtollerSetting;
	IBOutlet BackgroundController*		m_controllerBackground;
	IBOutlet AlarmViewController*		m_controllerAlarm;
	
	BOOL		m_bSleeping;
	BOOL		m_bToolBarHidden;
	BOOL		m_bAnimation;

	int					m_nToday;
	NSUInteger			m_nIndex;
	NSUInteger			m_nIndexPrev;
	NSUInteger			m_nWeekDay;
	NSMutableArray*		m_arrayImage;
	
	MessageController*	m_messageController;
	AlarmInfo*			m_curAlarmInfo;
	BOOL				m_bShow;
}

@property (nonatomic, retain) UILabel*		m_labelDate;
@property (nonatomic) BOOL	m_bShow;

- (void)stopAniBackImage;
- (UIImageView*)setImageView:(int)index;
- (IBAction)actionSetting;
- (IBAction)actionBackground;
- (IBAction)actionAlarm;
- (IBAction)actionSleeping;

- (void)flipShowSetting:(UIView*)view;
- (void)popAlarmViewControler;
- (void)actionTouches;

- (IBAction)share:(id)sender;

@end
