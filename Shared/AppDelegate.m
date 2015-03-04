//
//  AppDelegate.m
//  WakeMe
//
//  Created by OCH-Mac on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "GameUtils.h"
#import <GooglePlus/GooglePlus.h>

static NSString * const kClientID =
@"450462826991.apps.googleusercontent.com";

@implementation AppDelegate

@synthesize window, navigationController;

#define LOGOVIEW_TAG	1000

- (void)scheduleNotification {
	[[UIApplication sharedApplication] cancelAllLocalNotifications];
	
	Class cls = NSClassFromString(@"UILocalNotification");
	if (cls != nil) {
		CFAbsoluteTime at = CFAbsoluteTimeGetCurrent();
		CFTimeZoneRef timeZone = CFTimeZoneCopySystem();
		CFGregorianDate data = CFAbsoluteTimeGetGregorianDate(at, timeZone);
		CFRelease(timeZone);
		
		NSDateComponents *comps = [[NSDateComponents alloc] init];
		[comps setYear:data.year];
		[comps setMonth:data.month];
		[comps setDay:data.day];
//		[comps setHour:m_TimeView.m_nAlarmHour];
//		[comps setMinute:m_TimeView.m_nAlarmMin];
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDate *fireDate = [gregorian dateFromComponents:comps];
		[comps release];
		
		NSDate* current = [NSDate date];
		NSTimeInterval interval = [fireDate timeIntervalSinceDate:current];
		
		UILocalNotification *notif = [[cls alloc] init];
		notif.timeZone = [NSTimeZone defaultTimeZone];
		
		if(interval < 0)
			notif.fireDate = [fireDate dateByAddingTimeInterval:24 * 3600];
		else
			notif.fireDate = fireDate;
		
		notif.alertBody = @"Alarm!";
		notif.alertAction = @"Launch App";
		notif.soundName = UILocalNotificationDefaultSoundName;
		notif.applicationIconBadgeNumber = 1;
		
		//		NSDictionary *userDict = [NSDictionary dictionaryWithObject:reminderText.text
		//															 forKey:kRemindMeNotificationDataKey];
		//		notif.userInfo = userDict;
		
		[[UIApplication sharedApplication] scheduleLocalNotification:notif];
		[notif release];
	}
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	
//    MainViewController *rootViewController = (MainViewController *)[navigationController topViewController];

    [GPPSignIn sharedInstance].clientID = kClientID;
    
	UIImageView* logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo.png"]];
	logoView.frame = [[UIScreen mainScreen] bounds];
	logoView.tag = LOGOVIEW_TAG;
	[window addSubview:logoView];

    [RevMobAds startSessionWithAppID:REVMOB_ID];
    
	[self performSelector:@selector(mainViewStart) withObject:nil afterDelay:2.0];
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation
{
    return [GPPURLHandler handleURL:url
                  sourceApplication:sourceApplication
                         annotation:annotation];
}
#pragma mark - GPPDeepLinkDelegate

- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink {
    // An example to handle the deep link data.
    UIAlertView *alert = [[[UIAlertView alloc]
                           initWithTitle:@"Deep-link Data"
                           message:[deepLink deepLinkID]
                           delegate:nil
                           cancelButtonTitle:@"OK"
                           otherButtonTitles:nil] autorelease];
    [alert show];
}
- (void)mainViewStart {
//    RevMobFullscreen *fs = [[RevMobAds session] fullscreen];
//    fs.delegate = self;
//    [fs showAd];
    
    [self showBoardView];
}

- (void) showBoardView {
    UIView* logoView = [window viewWithTag:LOGOVIEW_TAG];
	[logoView removeFromSuperview];
	[logoView release];
	
	navigationController.navigationBar.hidden = YES;
	[window addSubview:[navigationController view]];
    
}

#pragma mark - RevMobAdsDelegate methods

- (void)revmobAdDidReceive {
    NSLog(@"[RevMob Sample App] Ad loaded.");
}

- (void)revmobAdDidFailWithError:(NSError *)error {
    NSLog(@"[RevMob Sample App] Ad failed: %@", error);

    [self showBoardView];
}
- (void)revmobUserClosedTheAd {
    NSLog(@"[RevMob Sample App] User clicked in the close button.");
    
    [self showBoardView];
  
}
- (void)revmobUserClickedInTheAd
{
    NSLog(@"[RevMob] Fullscreen clicked.");

    [self showBoardView];
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	// UIApplicationState state = [application applicationState];
	// if (state == UIApplicationStateInactive) {
	
	// Application was in the background when notification
	// was delivered.
	// }
//	application.applicationIconBadgeNumber = 0;
	//	NSString *reminderText = [notification.userInfo objectForKey:kRemindMeNotificationDataKey];
	//	[self showReminder:reminderText];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	[g_GameUtils writeEnvironment];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
//	[self scheduleNotification];
//	application.applicationIconBadgeNumber = 0;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	[g_GameUtils writeEnvironment];
	[g_GameUtils closeDB];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void)dealloc {
	[navigationController release];
    [window release];
    [super dealloc];
}

@end