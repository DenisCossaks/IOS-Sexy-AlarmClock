//
//  SettingViewController.h
//  WakeMe
//
//  Created by OCH-Mac on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RevMobAds/RevMobAds.h>

@class MainViewController;

@interface SettingViewController : UIViewController <UITableViewDelegate> {
	IBOutlet MainViewController*		mainViewController;
    
}

//@property(nonatomic,retain)RevMobBanner *banner;

- (IBAction)actionDone;

@end
