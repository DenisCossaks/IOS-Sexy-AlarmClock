//
//  MainViewController.m
//  WakeMe
//
//  Created by OCH-Mac on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"
#import "SettingViewController.h"
#import "BackgroundController.h"
#import "AlarmViewController.h"
#import "GameUtils.h"
#import "AlarmInfo.h"
#import "SoundEngine.h"
#import "ShareViewController.h"

static const NSString* s_strWeek[] = {
	 @"Sunday", @"Monday", @"Tuesday", @"Wednesday", @"Thursday", @"Friday", @"Saturday",
};


@interface MainViewController (PrivateMethods)
- (void)drawTimeView;
- (void)procTimerBackground;
- (void)updateDay:(CFGregorianDate)data;
- (void)procAlarm:(AlarmInfo*)info;
- (UIView*)currentImageView;
@end

@implementation MainViewController

@synthesize m_labelDate, m_bShow;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	g_GameUtils = [[GameUtils alloc] init];
	
	m_bSleeping			= NO;
	m_bToolBarHidden	= YES;
	m_bAnimation		= NO;
	m_nIndex			= 0;
	m_nIndexPrev		= 0;
	m_nToday			= 0;
	m_timerSlide		= nil;
	m_timerSlide = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(procTimerBackground) userInfo:nil repeats:YES];
	
	if(g_nImageSelectCount > 0)
		[self setImageView:g_nImageSelect[m_nIndex]];
	m_messageController = nil;
	
	srandom(time(NULL));
	m_bShow = YES;
}

#pragma mark - UIButton methods

- (IBAction)share:(id)sender {
    ShareViewController *objshare = [[ShareViewController alloc]init];
    [self.navigationController pushViewController:objshare animated:YES];
    
}
- (IBAction)actionSetting {
	[self flipShowSetting:m_conrtollerSetting.view];
}

- (IBAction)actionBackground {
	[self flipShowSetting:m_controllerBackground.view];
}

- (IBAction)actionAlarm {
//	AlarmViewController* addController = [[AlarmViewController alloc] initWithNibName:@"AlarmView_iPhone" bundle:nil];
//	addController.mainViewController = self;
//    [self.navigationController pushViewController:addController animated:YES];
//	[addController release];
	[self flipShowSetting:m_controllerAlarm.view];
}

- (IBAction)actionSleeping {
	if(m_bAnimation)
		return;
	m_bSleeping = !m_bSleeping;
	UIView* view = [self currentImageView];
	
	if(m_bSleeping) {
//		[self stopAniBackImage];
		[m_itemSleeping setTitle:@"Wake Up"];
	}
	else {
		[m_itemSleeping setTitle:@"Sleeping"];
		if(view == nil && g_nImageSelectCount > 0) {
			[self setImageView:g_nImageSelect[m_nIndex]];
			view = [self currentImageView];
			view.alpha = 0.0;
		}
	}
	
	m_bAnimation = YES;
	CGRect rect = self.view.bounds;
	CGContextRef context = UIGraphicsGetCurrentContext();
	[UIView beginAnimations:nil context:context];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:1.0];
	if(!m_bSleeping) {
		m_timeView.center = CGPointMake(rect.size.width / 2.0, rect.size.height - 60.0);
		view.alpha = 1.0;
	}
	else {
		view.alpha = 0.0;
	}
	m_toolBar.alpha = 0.0;
	[UIView setAnimationDidStopSelector:@selector(notifyStopAnimationView)];
	[UIView setAnimationDelegate:self];
	[UIView commitAnimations];
}

#pragma mark Other methods
- (void)flipShowSetting:(UIView*)settingView {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationTransition:([settingView superview] ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight) forView:self.view cache:YES];
	
	if ([settingView superview]) {
		[settingView removeFromSuperview];
		if(g_nImageSelectCount > 0 && !m_bSleeping)
			[self setImageView:g_nImageSelect[m_nIndex]];
		[self.view addSubview:m_background];
		m_timerSlide = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(procTimerBackground) userInfo:nil repeats:YES];
		m_bShow = YES;
	} else {
		if(m_timerSlide != nil) {
			[m_timerSlide invalidate];
			m_timerSlide = nil;
		}
		[self stopAniBackImage];
		[m_background removeFromSuperview];
		[self.view addSubview:settingView];
		m_bShow = NO;
	}
	[UIView commitAnimations];
}

- (void)actionTouches {
	if(m_bAnimation)
		return;
	m_bAnimation = YES;
	if(m_bToolBarHidden) {
		m_toolBar.hidden = NO;
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		if(!m_bSleeping)
			m_timeView.center = CGPointMake(m_timeView.center.x, m_timeView.center.y - 40);
		m_toolBar.alpha = 1.0;
		[UIView setAnimationDidStopSelector:@selector(notifyStopAnimationView)];
		[UIView setAnimationDelegate:self];
		[UIView commitAnimations];
	}
	else {
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.8];
		if(!m_bSleeping)
			m_timeView.center = CGPointMake(m_timeView.center.x, m_timeView.center.y + 40);
		m_toolBar.alpha = 0.0;
		[UIView setAnimationDidStopSelector:@selector(notifyStopAnimationView)];
		[UIView setAnimationDelegate:self];
		[UIView commitAnimations];
	}
}

- (void)notifyStopAnimationView {
	m_bAnimation = NO;
	if(!m_bToolBarHidden)
		m_toolBar.hidden = YES;
	m_bToolBarHidden = !m_bToolBarHidden;
}

- (BOOL)checkAlarmTime:(CFGregorianDate)data {
	int nCount = [g_GameUtils.dataArray count];
	for(int i = 0; i < nCount; i++) {
		AlarmInfo* info = [[g_GameUtils getAlarmInfo:i] autorelease];
		if(!info.isEnable)
			continue;
		if(info.period & (1 << m_nWeekDay) && data.hour == info.alarmHour && data.minute == info.alarmMin) {
			if(g_GameUtils.m_bAlarmEnable) {
				[g_GameUtils procAlarmStandby];
				[self procAlarm:info];
				return YES;
			}
		}
	}

	return NO;
}

static const int s_snoozeTime[] = {
	0, 3, 5, 10, 15, 20, 25, 30,
};
static AlarmInfo*	s_curAlarmInfo = nil; // = [[AlarmInfo alloc] init];

- (void)procAlarm:(AlarmInfo*)info {
	m_bShow = NO;
	if(m_messageController != nil) {
		[m_messageController release];
		m_messageController = nil;
	}
	m_messageController = [[MessageController alloc] initWithNibName:@"AlarmMessage_iPhone" bundle:nil];
	m_messageController.delegate = self;
	
	[m_messageController showMessage:info];
	
    [self presentViewController:m_messageController animated:YES completion:nil];
    
    NSString * soundName = info.strSoundFileName;
	[g_GameUtils playBackgroundMusic:soundName Ext:@"wav"];
//    [g_GameUtils playSoundEffect:info.strSound Ext:@"wav"];

    
	if(info.snoozeTime > 0)
		s_curAlarmInfo = [info retain];
}

- (void)procSnnozeAlarm {
	[self procAlarm:s_curAlarmInfo];
}

- (void)drawTimeView {
	CFAbsoluteTime at = CFAbsoluteTimeGetCurrent();
	CFTimeZoneRef timeZone = CFTimeZoneCopySystem();
	CFGregorianDate data = CFAbsoluteTimeGetGregorianDate(at, timeZone);
	CFRelease(timeZone);
	
	[self checkAlarmTime:data];
	
	int hour = data.hour;
	if(g_GameUtils.m_bHour24) {
		m_labelAM.text = @"";
	}
	else {
		if(hour > 12) {
			hour -= 12;
			m_labelAM.text = @"PM";
		}
		else {
			m_labelAM.text = @"AM";
		}
	}
	m_labelHour.text = [NSString stringWithFormat:@"%02d", hour];
	m_labelMin.text = [NSString stringWithFormat:@"%02d", data.minute];
	static BOOL bFlag = YES;
	if(bFlag)
		m_labelSemi.text = @":";
	else
		m_labelSemi.text = @"";
	bFlag = !bFlag;
	
	[self updateDay:data];
	if(m_imgAlarmMark.hidden) {
		if([g_GameUtils.dataArray count] > 0)
			m_imgAlarmMark.hidden = NO;
	}
	else {
		if([g_GameUtils.dataArray count] <= 0)
			m_imgAlarmMark.hidden = YES;
	}
	//	if(m_nToday != data.day)
	//		[self updateDay:data];
}

- (UIImageView*)setImageView:(int)index {
	if(index < 0 || index >= 20) {
		return nil;
	}
	UIView* view = [m_background viewWithTag:m_nIndex + 1000];
	if(view != nil) {
		[view removeFromSuperview];
		view = nil;
	}

	UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"Back%d.jpg", index]];
	UIImageView* imageView = [[UIImageView alloc] initWithFrame:m_background.frame];
	imageView.image = image;
	
//	CGRect rect = [self.view bounds];
//	CGFloat height = (rect.size.width / image.size.width) * image.size.height;
//	imageView.frame = CGRectMake(0, (rect.size.height - height) / 2.0, rect.size.width, height);

	[m_background insertSubview:imageView atIndex:0];
	imageView.tag = m_nIndex + 1000;
	[imageView release];
	return imageView;
}

- (UIView*)prevImageView {
	NSInteger tag = m_nIndexPrev + 1000;
//	if(tag < 1000)
//		tag = 1000 + g_nImageSelectCount - 1;
	return [m_background viewWithTag:tag];
}

- (UIView*)currentImageView {
	return [m_background viewWithTag:m_nIndex + 1000];
}

- (void)procTimerBackground {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	if(!m_bShow) {
		[pool release];
		return;
	}
	[self drawTimeView];
	static int nDrawIndex = 0;
	nDrawIndex++;
	if(nDrawIndex % g_GameUtils.m_slideInterval != 0) {
		[pool release];
		return;
	}
	
	if(m_bSleeping) {
//		UIView* curView = [self currentImageView];
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
//		curView.alpha = 0.0;
		CGSize size = [m_timeView bounds].size;
		CGRect rect = [self.view bounds];
		CGFloat x = size.width / 2.0 + random() % (int)(rect.size.width - size.width);
		CGFloat y = size.height / 2.0 + random() % (int)(rect.size.height - size.height);
		m_timeView.center = CGPointMake(x, y);
		[UIView setAnimationDidStopSelector:nil];
		[UIView setAnimationDelegate:self];
		[UIView commitAnimations];
	}
	else {
		if(g_nImageSelectCount <= 1)  {
			[pool release];
			return;
		}
		
		m_nIndexPrev = m_nIndex;
		m_nIndex++;
		if(m_nIndex >= g_nImageSelectCount)
			m_nIndex = 0;
		
		UIView* prevView = [self prevImageView];
		UIImageView* imageView = [self setImageView:g_nImageSelect[m_nIndex]];
		imageView.alpha = 0;
		
		CGContextRef context = UIGraphicsGetCurrentContext();
		[UIView beginAnimations:nil context:context];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:1.0];
		imageView.alpha = 1.0;
		prevView.alpha = 0.0;
		[UIView setAnimationDidStopSelector:@selector(notifyStopBackSlide)];
		[UIView setAnimationDelegate:self];
		[UIView commitAnimations];
	}
	
	[pool release];

}

- (void)notifyStopBackSlide {
	UIView* prevView = [self prevImageView];
	if(prevView != nil) {
		[prevView removeFromSuperview];
//		[prevView release];
		prevView = nil;
	}
}

- (void)stopAniBackImage {
	if(g_nImageSelectCount <= 0)
		return;
	UIView* prevView = [self currentImageView];
	if(prevView != nil) {
		[prevView removeFromSuperview];
//		[prevView release];
		prevView = nil;
	}
	m_nIndex = 0;
}

- (void)updateDay:(CFGregorianDate)data {
	if(!g_GameUtils.m_bDisplayDate) {
		m_labelDate.text = @"";
		return;
	}
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setDay:data.day];
	[comps setMonth:data.month];
	[comps setYear:data.year];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDate *date = [gregorian dateFromComponents:comps];
	[comps release];
	NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
	int nWeekday = [weekdayComponents weekday] - 1; //1:Sunday
	m_nWeekDay = nWeekday;
	[gregorian release];
	
	m_labelDate.text = [NSString stringWithFormat:@"%04d %02d %02d   %@", (int)data.year, data.month, data.day, s_strWeek[nWeekday]];
	m_nToday = data.day;
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark - Controller delegete
#pragma mark AlarmMessage

- (void)stopAlarmDelegate:(MessageController*)controller {
	[g_GameUtils stopBackgroundMusic];

    [self dismissViewControllerAnimated:YES completion:nil];
    
	if(s_curAlarmInfo != nil) {
		[s_curAlarmInfo release];
		s_curAlarmInfo = nil;
	}
	controller.m_bShow = NO;
	m_bShow = YES;
}

- (void)snoozeAlarmDelegate:(MessageController*)controller {
	[g_GameUtils stopBackgroundMusic];
    [self dismissViewControllerAnimated:YES completion:nil];
    
	if(s_curAlarmInfo != nil && s_curAlarmInfo.snoozeTime > 0)
		[self performSelector:@selector(procSnnozeAlarm) withObject:nil afterDelay:s_snoozeTime[s_curAlarmInfo.snoozeTime] * 60];
	controller.m_bShow = NO;
	m_bShow = YES;
}

- (void)popAlarmViewControler {
//	[self.navigationController popViewControllerAnimated:YES];
//	[self performSelector:@selector(actionAfterDelay) withObject:nil afterDelay:1.0];
}

- (void)actionAfterDelay {
	m_bShow = YES;
}


@end
