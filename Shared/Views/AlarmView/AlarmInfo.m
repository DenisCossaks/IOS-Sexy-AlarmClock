//
//  AlarmInfo.m
//  WakeMe
//
//  Created by OCH-Mac on 2/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlarmInfo.h"
#import "GameUtils.h"

enum {
    PeriodSundayMask		= 1 << 0,
    PeriodMondayMask		= 1 << 1,
    PeriodTuesdayMask		= 1 << 2,
    PeriodWednesdayMask		= 1 << 3,
    PeriodThirddayMask		= 1 << 4,
    PeriodFridayMask		= 1 << 5,
    PeriodThursdayMask		= 1 << 6,
};
typedef NSUInteger PeriodMask;

#define	EVERY_PEROID		0xff

@implementation AlarmInfo

static const NSString* s_strSnnozeTime[] = {
	@"No Snooze", @"3 Min", @"5 Min", @"10 Min", @"15 Min", @"20 Min", @"25 Min", @"30 Min",
};

static const NSString* s_strPeroid[] = {
	@"Every day", @"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat",
};

static const NSString* s_strSound[] = {
	@"C'est l'heure de se rÈveiller", @"Croissants Surprise", @"RÈveil avec Anissa Kate", @"RÈveil Chaud", @"RÈveil Militaire",@"On the Road 66",@"Black Sex Addict",@"Mafiosi",@"Purgatoire",@"Soumission Anale",@"Testament",@"Ultimate French Girls 1",@"Ultimate French Girls 2",@"Ultimate French Girls 3",
};

static const NSString* s_strSoundFileName[] = {
	@"c-est-l-heure", @"croissants-surprise", @"Reveil-avec-Anissa", @"Reveil-chaud", @"Reveil-militaire",@"Anissa Kate On the Road 66",@"Black Sex Addict",@"Mafiosi",@"Purgatoire",@"Soumission Anale",@"Testament",@"Ultimate French Girls 1",@"Ultimate French Girls 2",@"Ultimate French Girls 3"
};

@synthesize key, strMessage, snoozeTime, period, sound, alarmImage, alarmHour, alarmMin, isEnable;
@synthesize strSnoozeTime, strPeriod, strSound, strSoundFileName, idSoundPod, imageAlarm;

- (id)init {
	if(self = [super init]) {
		key = 0;
		self.strMessage	= @"My ringtone";
		self.snoozeTime	= 0;
		period		= EVERY_PEROID;
		sound		= 0;
		alarmImage	= 0;
		
		CFAbsoluteTime at = CFAbsoluteTimeGetCurrent();
		CFTimeZoneRef timeZone = CFTimeZoneCopySystem();
		CFGregorianDate data = CFAbsoluteTimeGetGregorianDate(at, timeZone);
		CFRelease(timeZone);
		alarmHour	= data.hour;
		alarmMin	= data.minute;
		
		isEnable	= YES;
	}
	return self;
}

- (NSString*)strSnoozeTime {
	return [s_strSnnozeTime[snoozeTime] copy];
}

- (NSString*)strPeriod {
	NSString* str = @"";
	if(period == EVERY_PEROID) {
		return [s_strPeroid[0] copy];
	}
	else {
		for(int i = 0; i < 7; i++) {
			if(period & (1 << i))
				str = [str stringByAppendingFormat:@"%@ ", s_strPeroid[i + 1]];
		}
	}
	return str;
}

- (NSString*)strSound {
	if(sound < DEFAULT_SOUNDCOUNT)
		return [s_strSound[sound] copy];
	else
		return nil;
}
- (NSString*)strSoundFileName {
	if(sound < DEFAULT_SOUNDCOUNT)
		return [s_strSoundFileName[sound] copy];
	else
		return nil;
}

- (UIImage*)imageAlarm {
	UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"Back%d.jpg", alarmImage]];
	UIImage* thumbImage = [GameUtils getThumbnailImage:image WithSize:CGSizeMake(50, 50)];
	[image release];
	return thumbImage;
}

- (BOOL)IsWeekdaySelect:(NSUInteger)weekday {
	NSUInteger mask = 1 << weekday;
	return period & mask;
}

//- (void)setSnoozeTime:(NSUInteger)value {
//	strSnoozeTime = [s_strSnnozeTime[value] copy];
//	snoozeTime = value;
//}
//
//- (void)setPeriod:(NSUInteger)value {
//	if(value == EVERY_PEROID) {
//		strPeriod = [s_strPeroid[0] copy];
//	}
//	else {
//		NSString* str = @"";
//		for(int i = 0; i < 7; i++) {
//			if(value & (1 << i))
//				str = [str stringByAppendingFormat:@"%@ ", s_strPeroid[i + 1]];
//		}
//		strPeriod = [str copy];
//	}
//	period = value;
//}

@end