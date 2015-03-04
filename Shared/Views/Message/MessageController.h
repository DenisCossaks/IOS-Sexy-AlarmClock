//
//  MessageController.h
//  WakeMe
//
//  Created by OCH-Mac on 2/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageControllerDelegate;

@class AlarmInfo;
@interface MessageController : UIViewController {
	id <MessageControllerDelegate>	delegate;
	IBOutlet UIImageView*	m_imgBack;
	IBOutlet UIImageView*	m_imgMessage;
	IBOutlet UILabel*		m_labelMessage;
	IBOutlet UIButton*		m_btnStop;
	IBOutlet UIButton*		m_btnSnooze;
	
	AlarmInfo*	m_alarmInfo;
	BOOL		m_bShow;
}

@property (nonatomic, retain) id <MessageControllerDelegate> delegate;
@property (nonatomic) BOOL	m_bShow;

- (IBAction)actionStop:(id)sender;
- (IBAction)actionSnooze:(id)sender;
- (void)showMessage:(AlarmInfo*)info;

@end

@protocol MessageControllerDelegate
- (void)stopAlarmDelegate:(MessageController*)controller;
- (void)snoozeAlarmDelegate:(MessageController*)controller;
@end
