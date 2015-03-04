//
//  GameUtils.m
//  MonkeyTime
//
//  Created by OCH on 11/01/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameUtils.h"
#import "SoundEngine.h"
#import "AlarmInfo.h"

GameUtils*			g_GameUtils;// = [[GameUtils alloc] init];
NSUInteger			g_nImageSelect[20];
NSUInteger			g_nImageSelectCount;

@interface GameUtils (PrivateMethods)
- (void)readEnvironment;
- (void)openDB;
- (void)closeDB;
@end

@implementation GameUtils

@synthesize isIdiomphone		= m_bIdiomPhone;
@synthesize scaleWidth			= m_scaleWidth;
@synthesize scaleHeight			= m_scaleHeight;
@synthesize nImageCount			= m_nImageCount;
@synthesize dataArray, arraySound, arrayImage, m_bAlarmEnable;

@synthesize m_bHour24, m_bDisplayDate, m_bCancelStandby, m_slideInterval;

// on "init" you need to initialize your instance
- (id)init
{
	if( (self = [super init] )) {
		m_scaleWidth			= SCALE_SCREEN_WIDTH;
		m_scaleHeight			= SCALE_SCREEN_HEIGHT;
		
		if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
			m_bIdiomPhone	= YES;
		else
			m_bIdiomPhone	= NO;
		
		m_bHour24			= YES;
		m_bDisplayDate		= YES;
		m_bCancelStandby	= YES;
		m_slideInterval		= 5;
		m_bAlarmEnable		= YES;
		
		[self readEnvironment];
		[self openDB];
	}
	return self;
}

- (void)readEnvironment {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	m_nImageCount = [defaults integerForKey:@"BackgroundImage Count"];
	BOOL bFirst = [defaults boolForKey:@"FirstApp"];
	if(!bFirst) {
		g_nImageSelectCount = 14;
		for(int i = 0; i < g_nImageSelectCount; i++)
			g_nImageSelect[i] = i;
		
		m_bHour24			= YES;
		m_bDisplayDate		= YES;
		m_bCancelStandby	= YES;
		m_slideInterval		= 30;
	}
	else {
		g_nImageSelectCount = [defaults integerForKey:@"BackgroundImage Count"];
		for(int i = 0; i < g_nImageSelectCount; i++)
			g_nImageSelect[i] = [defaults integerForKey:[NSString stringWithFormat:@"BackgroundImagePossible%d", i]];
		
		m_bHour24			= [defaults boolForKey:@"24Hour Mode"];
		m_bDisplayDate		= [defaults boolForKey:@"Display Date"];
		m_bCancelStandby	= [defaults boolForKey:@"Standby Cancel"];
		m_slideInterval		= [defaults integerForKey:@"SliderInterval"];
		if(m_slideInterval <= 0)
			m_slideInterval = 5;
	}
	[[UIApplication sharedApplication] setIdleTimerDisabled:m_bCancelStandby];
}

- (void)writeEnvironment {
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	[defaults setInteger:YES forKey:@"FirstApp"];
	[defaults setInteger:g_nImageSelectCount forKey:@"BackgroundImage Count"];
	for(int i = 0; i < g_nImageSelectCount; i++)
		[defaults setInteger:g_nImageSelect[i] forKey:[NSString stringWithFormat:@"BackgroundImagePossible%d", i]];
	
	[defaults setBool:m_bHour24 forKey:@"24Hour Mode"];
	[defaults setBool:m_bDisplayDate forKey:@"Display Date"];
	[defaults setBool:m_bCancelStandby forKey:@"Standby Cancel"];
	[defaults setInteger:m_slideInterval forKey:@"SliderInterval"];
	
	[defaults synchronize];
}

- (void)applicationWillTerminate {
	[self writeEnvironment];
	[self closeDB];
}

- (AlarmInfo*)getAlarmInfo:(NSUInteger)index {
	NSArray* data = self.dataArray;
	int nCount = data.count;
	if(index >= nCount)
		return nil;
	
	NSDictionary* dataDictionary = [data objectAtIndex:index];
	AlarmInfo* info = [[AlarmInfo alloc] init];
	
	NSString* str = [dataDictionary objectForKey:@"Message"];
	info.strMessage = str;
	NSNumber* number = [dataDictionary objectForKey:@"SnoozeTime"];
	info.snoozeTime = [number unsignedIntValue];
//	[number release];
	number = [dataDictionary objectForKey:@"Period"];
	info.period = [number unsignedIntValue];
//	[number release];
	number = [dataDictionary objectForKey:@"Sound"];
	info.sound = [number unsignedIntValue];
//	[number release];
	number = [dataDictionary objectForKey:@"Image"];
	info.alarmImage = [number unsignedIntValue];
//	[number release];
	number = [dataDictionary objectForKey:@"AlarmHour"];
	info.alarmHour = [number unsignedIntValue];
//	[number release];
	number = [dataDictionary objectForKey:@"AlarmMin"];
	info.alarmMin = [number unsignedIntValue];
//	[number release];
	number = [dataDictionary objectForKey:@"isEnable"];
	info.isEnable = [number boolValue];
//	[number release];
	
//	[dataDictionary release];
//	[data release];
	
	return info;
}

#pragma mark -
#pragma mark Application's documents directory

- (void)openDB {
    if (database == NULL) {
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"data.sqlite"];
		
        if ([fileManager fileExistsAtPath:writableDBPath] == NO) {
            NSString *defaultDBPath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"sqlite"];
            success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
            if (!success) {
                NSCAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
            }
        }
		
        if (sqlite3_open([writableDBPath UTF8String], &database) != SQLITE_OK) {
            sqlite3_close(database);
            database = NULL;
            NSCAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(database));
        }
	}
	[self readAllData];
}

- (void)closeDB {
    if(database == NULL) 
		return;
	
    if(sqlite3_close(database) != SQLITE_OK) {
        NSCAssert1(0, @"Error: failed to close database with message '%s'.", sqlite3_errmsg(database));
    }
    database = NULL;
}


#define DOCSFOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

- (void)addBackImage:(UIImage*)image {
	NSString* pathFace = [NSString stringWithFormat:@"%@/%@-%03d.%@", DOCSFOLDER, @"background", m_nImageCount, @"png"];
	
//	NSString *pathFace = [DOCSFOLDER stringByAppendingPathComponent:@"background001.png"]; 
//	while ([[NSFileManager defaultManager] fileExistsAtPath:pathFace])
//		pathFace = [NSString stringWithFormat:@"%@/%@-%03d.%@", DOCSFOLDER, @"background", ++i, @"png"];
//	printf("Writing selected image to Documents folder\n"); 
	[UIImagePNGRepresentation(image)writeToFile:pathFace atomically:YES];
	m_nImageCount++;
}

- (void)procAlarmStandby {
	m_bAlarmEnable = NO;
	
	CFAbsoluteTime at = CFAbsoluteTimeGetCurrent();
	CFTimeZoneRef timeZone = CFTimeZoneCopySystem();
	CFGregorianDate data = CFAbsoluteTimeGetGregorianDate(at, timeZone);
	CFRelease(timeZone);
	
	[self performSelector:@selector(procAlarmAfter) withObject:nil afterDelay:60 - data.second];
}

- (void)procAlarmAfter {
	if(!m_bAlarmEnable)
		m_bAlarmEnable = YES;
}

- (void)replaceAlarmInfo:(NSUInteger)nIndex Info:(AlarmInfo*)info {
	if(database == nil)
		return;
	
	NSArray* data = self.dataArray;
	int nCount = data.count;
	if(nCount <= nIndex)
		return;
	
	NSDictionary* dataDictionary = [data objectAtIndex:nIndex];
	NSNumber* ID = [dataDictionary objectForKey: @"id"];
	int nID = [ID doubleValue];
	
	NSString *sql = [NSString stringWithFormat:@"UPDATE AlarmInfo SET isEnable = %d, Message = '%@', SnoozeTime = %d, Period = %d, Sound = %d, Image = %d, AlarmHour = %d, AlarmMin = %d WHERE id=%d", 
					 (int)(info.isEnable), info.strMessage, info.snoozeTime, info.period, info.sound, info.alarmImage, info.alarmHour, info.alarmMin, nID];
	NSLog(@"%@", sql);
	
	sqlite3_stmt *statement;
	if (sqlite3_prepare(database,[sql UTF8String],-1,&statement,NULL) == SQLITE_OK)
	{
		sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
	[self readAllData];
	[self procAlarmStandby];
}

- (void)addAlarmInfo:(AlarmInfo*)info {
	if(info == nil)
		return;
	if(database == nil)
		return;
    
	int nKey = 0;
	
	NSString *sql = [NSString stringWithFormat:@"SELECT MAX(id) FROM AlarmInfo"];    	
	sqlite3_stmt *statement;
	if (sqlite3_prepare(database,[sql UTF8String],-1,&statement,NULL) == SQLITE_OK)
	{
		if (sqlite3_step(statement) == SQLITE_ROW) 
		{		
			nKey = sqlite3_column_int(statement,0);
		}
	}
	
	sqlite3_finalize(statement);
	nKey++;
	
	NSString *sql1 = [NSString stringWithFormat:@"insert into AlarmInfo (isEnable, id, Message, SnoozeTime, Period, Sound, Image, AlarmHour, AlarmMin) VALUES(%d, %d, '%@', %d, %d, %d, %d, %d, %d)",
					  (int)(info.isEnable), nKey, info.strMessage, info.snoozeTime, info.period, info.sound, info.alarmImage, info.alarmHour, info.alarmMin];    	
	NSLog(@"%@", sql1);
	if(sqlite3_prepare(database, [sql1 UTF8String], -1, &statement, NULL) == SQLITE_OK)    
	{
        NSLog( @"insert ok" );
	} 
	if(sqlite3_step(statement) != SQLITE_DONE ) 
	{ 
		NSLog( @"Error: %s", sqlite3_errmsg(database) ); 
	}
	else 
	{ 
		NSLog( @"Insert into row id = %lld", sqlite3_last_insert_rowid(database));
	}
    
	sqlite3_finalize(statement); 
	[self readAllData];
	[self procAlarmStandby];
}

- (void)removeAlarmInfo:(NSUInteger)index {
	if(database == nil)
		return;
	
	NSArray* data = self.dataArray;
	int nCount = data.count;
	if(nCount <= index)
		return;
	
	NSDictionary* dataDictionary = [data objectAtIndex:index];
	NSNumber* ID = [dataDictionary objectForKey: @"id"];
	int nID = [ID doubleValue];
	
	NSString *sql = [NSString stringWithFormat:@"DELETE FROM AlarmInfo WHERE id=%d", nID];
	
	sqlite3_stmt *statement;
	if (sqlite3_prepare(database,[sql UTF8String],-1,&statement,NULL) == SQLITE_OK)
	{
		sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
	[self readAllData];
}

- (NSArray*)readAllData {
	
	NSString* sql = @"select * from AlarmInfo";
	sqlite3_stmt* statement;
	id result;
	
	if(dataArray != nil)
		[dataArray release];
	
	NSMutableArray* thisArray = [NSMutableArray arrayWithCapacity:9];
	if (sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSMutableDictionary* thisDict = [NSMutableDictionary dictionaryWithCapacity:9];
			for (int i = 0; i < sqlite3_column_count(statement); i++) {
				if (sqlite3_column_decltype(statement, i) != NULL &&
					strcasecmp(sqlite3_column_decltype(statement, i), "Boolean") == 0) {
					result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement, i) == SQLITE_TEXT) {
					result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_INTEGER) {
					result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT) {
					result = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];					
				} else {
					result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
				}
				if (result) {
					[thisDict setObject:result forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
				}
			}
			[thisArray addObject:[NSDictionary dictionaryWithDictionary:thisDict]];
		}
		
		sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
	dataArray = [thisArray retain];
	return thisArray;
}

#pragma mark Management Sound database

- (void)replaceSoundInfo:(NSUInteger)nIndex Info:(NSUInteger)info {
	if(database == nil)
		return;
	
	NSArray* data = self.arraySound;
	int nCount = data.count;
	if(nCount <= nIndex)
		return;
	
	NSDictionary* dataDictionary = [data objectAtIndex:nIndex];
	NSNumber* ID = [dataDictionary objectForKey: @"id"];
	int nID = [ID doubleValue];
	
	NSString *sql = [NSString stringWithFormat:@"UPDATE Sound SET PodMusicID = %d WHERE id=%d", info, nID];
	NSLog(@"%@", sql);
	
	sqlite3_stmt *statement;
	if (sqlite3_prepare(database,[sql UTF8String],-1,&statement,NULL) == SQLITE_OK)
	{
		sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
}

- (void)addSoundInfo:(NSUInteger)info {
	if(database == nil)
		return;
	int nKey;
	
	NSString *sql = [NSString stringWithFormat:@"SELECT MAX(id) FROM Sound"];
	sqlite3_stmt *statement;
	if (sqlite3_prepare(database,[sql UTF8String],-1,&statement,NULL) == SQLITE_OK)
	{
		if (sqlite3_step(statement) == SQLITE_ROW) 
		{		
			nKey = sqlite3_column_int(statement,0);
		}
	}
	
	sqlite3_finalize(statement);
	nKey++;
	
	NSString *sql1 = [NSString stringWithFormat:@"insert into Sound (id, PodMusicID) VALUES(%d, %d)", nKey, info];    	
	NSLog(@"%@", sql1);
	if(sqlite3_prepare(database, [sql1 UTF8String], -1, &statement, NULL) == SQLITE_OK)    
	{ 
	} 
	if(sqlite3_step(statement) != SQLITE_DONE ) 
	{ 
		NSLog( @"Error: %s", sqlite3_errmsg(database) ); 
	}
	else 
	{ 
		NSLog( @"Insert into row id = %lld", sqlite3_last_insert_rowid(database));
	} 
	sqlite3_finalize(statement);
	[self readAllData];
}

- (void)removeSoundInfo:(NSUInteger)index {
	if(database == nil)
		return;
	
	NSArray* data = self.dataArray;
	int nCount = data.count;
	if(nCount <= index)
		return;
	
	NSDictionary* dataDictionary = [data objectAtIndex:index];
	NSNumber* ID = [dataDictionary objectForKey: @"id"];
	int nID = [ID doubleValue];
	
	NSString *sql = [NSString stringWithFormat:@"DELETE FROM AlarmInfo WHERE id=%d", nID];
	
	sqlite3_stmt *statement;
	if (sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
}

#pragma mark -
#pragma mark Application's documents directory

/**
 Returns the path to the application's documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

//#pragma mark Array getter
//
//- (NSArray*)dataArray {
//	if (database == NULL)
//		return nil;
//	return [self readAllData];
//}

- (NSArray*)arraySound {
	if (database == NULL)
		return nil;
	
	NSString* sql = @"select * from Sound";
	sqlite3_stmt* statement;
	id result;
	
	NSMutableArray* thisArray = [NSMutableArray arrayWithCapacity:2];
	if (sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSMutableDictionary* thisDict = [NSMutableDictionary dictionaryWithCapacity:2];
			for (int i = 0; i < sqlite3_column_count(statement); i++) {
				if (sqlite3_column_decltype(statement, i) != NULL &&
					strcasecmp(sqlite3_column_decltype(statement, i), "Boolean") == 0) {
					result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement, i) == SQLITE_TEXT) {
					result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_INTEGER) {
					result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT) {
					result = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];					
				} else {
					result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
				}
				if (result) {
					[thisDict setObject:result
								 forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
				}
			}
			[thisArray addObject:[NSDictionary dictionaryWithDictionary:thisDict]];
		}
		
		sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
	return thisArray;
}

- (NSArray*)arrayImage {
	if (database == NULL)
		return nil;
	
	NSString* sql = @"select * from Image";
	sqlite3_stmt* statement;
	id result;
	
	NSMutableArray* thisArray = [NSMutableArray arrayWithCapacity:2];
	if (sqlite3_prepare(database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
	{
		while (sqlite3_step(statement) == SQLITE_ROW) {
			NSMutableDictionary* thisDict = [NSMutableDictionary dictionaryWithCapacity:2];
			for (int i = 0; i < sqlite3_column_count(statement); i++) {
				if (sqlite3_column_decltype(statement, i) != NULL &&
					strcasecmp(sqlite3_column_decltype(statement, i), "Boolean") == 0) {
					result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement, i) == SQLITE_TEXT) {
					result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_INTEGER) {
					result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT) {
					result = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];					
				} else {
					result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
				}
				if (result) {
					[thisDict setObject:result
								 forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
				}
			}
			[thisArray addObject:[NSDictionary dictionaryWithDictionary:thisDict]];
		}
		
		sqlite3_step(statement);
	}
	sqlite3_finalize(statement);
	return thisArray;
}

#pragma mark Universal Convert

- (NSString*)stringConvert:(NSString*)strName
{
	if(m_bIdiomPhone)
		return [NSString stringWithFormat:@"%@.png", strName];
	else
		return [NSString stringWithFormat:@"%@@3x.png", strName];
}

- (NSString*)stringConvert:(NSString*)strName Extension:(NSString*)strExt
{
	if(m_bIdiomPhone)
		return [NSString stringWithFormat:@"%@.%@", strName, strExt];
	else
		return [NSString stringWithFormat:@"%@@3x.%@", strName, strExt];
}

- (void)playBackgroundMusic:(NSString*)str Ext:(NSString*)strExt
{
	SoundEngine_StopBackgroundMusic(FALSE);
    
    NSLog(@"background name = %@", str);
    
	NSBundle* bundle = [NSBundle mainBundle];
	SoundEngine_LoadBackgroundMusicTrack([[bundle pathForResource:str ofType:strExt] UTF8String], FALSE, FALSE);
	SoundEngine_StartBackgroundMusic();
}

- (void)stopBackgroundMusic
{
	SoundEngine_StopBackgroundMusic(FALSE);
	SoundEngine_UnloadBackgroundMusicTrack();
}

static UInt32 s_outEffectID = 0;

- (void)playSoundEffect:(NSString*)str Ext:(NSString*)strExt
{
//	NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:strExt];
//	NSURL *url = [NSURL fileURLWithPath:path];
//	SystemSoundID soundID;	
//		
//	AudioServicesCreateSystemSoundID ((CFURLRef)url, &soundID);
//	AudioServicesPlaySystemSound(soundID);
//	[url release];
    
	SoundEngine_StopEffect(s_outEffectID, YES);
	SoundEngine_UnloadEffect(s_outEffectID);
	
    NSLog(@"sound name = %@", str);
    
	NSBundle* bundle = [NSBundle mainBundle];
	SoundEngine_LoadEffect([[bundle pathForResource:str ofType:strExt] UTF8String], &s_outEffectID);
	SoundEngine_StartEffect(s_outEffectID);
}

- (void)stopSoundEffect
{
	SoundEngine_StopEffect(s_outEffectID, YES);
	SoundEngine_UnloadEffect(s_outEffectID);
}

- (void)dealloc {
	[super dealloc];
}

+ (UIImage*)getThumbnailImage:(UIImage*)img WithSize:(CGSize)size {
	
    CGSize imgSize = img.size;
	CGFloat ratio = 0;
	if (imgSize.width > imgSize.height) {
		ratio = size.width / imgSize.width;
	} else {
		ratio = size.width / imgSize.height;
	}
	CGRect rect = CGRectMake(0.0, 0.0, ratio * imgSize.width, ratio * imgSize.height);
	
	UIGraphicsBeginImageContext(rect.size);
	[img drawInRect:rect];
	UIImage* thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
    return thumbnailImage;
}

+ (UIImage*)getSubImageFrom:(UIImage*)img WithRect:(CGRect)rect {
	
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    // translated rectangle for drawing sub image
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, img.size.width, img.size.height);
	
    // clip to the bounds of the image context
    // not strictly necessary as it will get clipped anyway?
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
	
    // draw image
    [img drawInRect:drawRect];
	
    // grab image
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return subImage;
}

@end
