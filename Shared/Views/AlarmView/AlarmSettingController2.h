//
//  AlarmSettingController.h
//  WakeMe
//
//  Created by OCH-Mac on 2/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AlarmInfo;
@protocol AlarmSettingControllerDelegate;

@interface AlarmSettingController : UIViewController {
	id <AlarmSettingControllerDelegate> delegate;
}

@property (nonatomic, assign) id <AlarmSettingControllerDelegate> delegate;
@property (nonatomic, retain) AlarmInfo*				alarmInfo;
@property (nonatomic, retain) IBOutlet UITextField*		editSubjet;
@property (nonatomic, retain) IBOutlet UISwitch*		switchSnooze;
@property (nonatomic, retain) IBOutlet UIButton*		btnSound;
@property (nonatomic, retain) IBOutlet UIDatePicker*	pickTime;

- (IBAction)actionSave:(id)sender;
- (IBAction)actionSound:(id)sender;

@end

@protocol AlarmSettingControllerDelegate
- (void)AlarmSettingController:(AlarmSettingController*)controller didFinishWithSave:(BOOL)save;
@end
