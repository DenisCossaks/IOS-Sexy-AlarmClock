//
//  PeriodController.h
//  WakeMe
//
//  Created by OCH-Mac on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>

@protocol PeriodControllerDelegate;

@interface PeriodController : UITableViewController {
	id <PeriodControllerDelegate>	delegate;
	NSUInteger	m_nPeriodValue;
    
}
//@property(nonatomic,retain)RevMobBanner *banner;


@property (nonatomic, retain) id <PeriodControllerDelegate> delegate;
@property (nonatomic) NSUInteger periodValue;

@end

@protocol PeriodControllerDelegate
- (void)updatePeriodDelegate:(PeriodController*)controller Value:(NSUInteger)value;
@end
