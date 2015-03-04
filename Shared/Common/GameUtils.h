//
//  GameUtils.h
//  MonkeyTime
//
//  Created by OCH on 11/01/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@class AlarmInfo;

@interface GameUtils : NSObject {
	CGFloat		m_scaleWidth;
	CGFloat		m_scaleHeight;
	BOOL		m_bIdiomPhone;
	
	BOOL		m_bHour24;
	BOOL		m_bDisplayDate;
	BOOL		m_bCancelStandby;
	NSUInteger	m_slideInterval;
	
	NSUInteger	m_nImageCount;
	
	sqlite3*	database;
	NSArray*	dataArray;
	NSArray*	arraySound;
	NSArray*	arrayImage;
	
	BOOL		m_bAlarmEnable;
}

@property (nonatomic,readonly,assign)	BOOL		isIdiomphone;
@property (nonatomic,readonly,assign)	CGFloat		scaleWidth;
@property (nonatomic,readonly,assign)	CGFloat		scaleHeight;
@property (nonatomic,readonly,assign)	NSUInteger	nImageCount;

@property (nonatomic) BOOL			m_bAlarmEnable;
@property (nonatomic) BOOL			m_bHour24;
@property (nonatomic) BOOL			m_bDisplayDate;
@property (nonatomic) BOOL			m_bCancelStandby;
@property (nonatomic) NSUInteger	m_slideInterval;

@property (nonatomic, readonly) NSString *applicationDocumentsDirectory;
@property (nonatomic, retain) NSArray*	dataArray;
@property (nonatomic, retain) NSArray*	arraySound;
@property (nonatomic, retain) NSArray*	arrayImage;

- (void)closeDB;

- (void)procAlarmStandby;
- (void)addAlarmInfo:(AlarmInfo*)info;
- (void)removeAlarmInfo:(NSUInteger)index;
- (void)replaceAlarmInfo:(NSUInteger)nIndex Info:(AlarmInfo*)info;
- (AlarmInfo*)getAlarmInfo:(NSUInteger)index;
- (NSArray*)readAllData;

- (void)applicationWillTerminate;
- (void)writeEnvironment;
- (NSString*)stringConvert:(NSString*)strName;
- (NSString*)stringConvert:(NSString*)strName Extension:(NSString*)strExt;

- (void)playBackgroundMusic:(NSString*)str Ext:(NSString*)strExt;
- (void)playSoundEffect:(NSString*)str Ext:(NSString*)strExt;
- (void)stopBackgroundMusic;
- (void)stopSoundEffect;

+ (UIImage*)getSubImageFrom:(UIImage*)img WithRect:(CGRect)rect;
+ (UIImage*)getThumbnailImage:(UIImage*)img WithSize:(CGSize)size;

@end

extern GameUtils*	g_GameUtils;
extern NSUInteger	g_nImageSelect[20];
extern NSUInteger	g_nImageSelectCount;
