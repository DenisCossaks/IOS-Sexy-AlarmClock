//
//  AlarmInfo.h
//  WakeMe
//
//  Created by OCH-Mac on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

#define	DEFAULT_SOUNDCOUNT	14

@interface AlarmInfo : NSObject {
	NSUInteger	key;
	NSString*	strMessage;
	NSUInteger	snoozeTime;
	NSUInteger	period;
	NSUInteger	sound;
	NSUInteger	alarmImage;
	NSUInteger	alarmHour;
	NSUInteger	alarmMin;
	BOOL		isEnable;
	
//	NSString*	strSnoozeTime;
//	NSString*	strPeriod;
//	NSString*	strSound;
//	UIImage*	imageAlarm;
}

@property (nonatomic)			NSUInteger	key;
@property (nonatomic, retain)	NSString*	strMessage;
@property (nonatomic)			NSUInteger	snoozeTime;
@property (nonatomic)			NSUInteger	period;
@property (nonatomic)			NSUInteger	sound;
@property (nonatomic)			NSUInteger	alarmImage;
@property (nonatomic)			NSUInteger	alarmHour;
@property (nonatomic)			NSUInteger	alarmMin;
@property (nonatomic)			BOOL		isEnable;


@property (nonatomic, retain)	NSString*	strSnoozeTime;
@property (nonatomic, retain)	NSString*	strPeriod;
@property (nonatomic, retain)	NSString*	strSound;
@property (nonatomic, retain)	NSString*	strSoundFileName;

@property (nonatomic)			int			idSoundPod;
@property (nonatomic, retain)	UIImage*	imageAlarm;

@end
