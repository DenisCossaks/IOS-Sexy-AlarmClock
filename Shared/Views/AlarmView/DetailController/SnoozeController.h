//
//  SnoozeController.h
//  WakeMe
//
//  Created by OCH-Mac on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>

@protocol SnoozeControllerDelegate;

@interface SnoozeController : UITableViewController {
	id <SnoozeControllerDelegate>	delegate;
	NSUInteger	m_nIndex;
    

}
//@property(nonatomic,retain)RevMobBanner *banner;

@property (nonatomic, retain) id <SnoozeControllerDelegate> delegate;
@property (nonatomic) NSUInteger index;

@end

@protocol SnoozeControllerDelegate
- (void)updateSnoozeDelegate:(SnoozeController*)controller Value:(NSUInteger)value;
@end
