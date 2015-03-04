//
//  AppDelegate.h
//  WakeMe
//
//  Created by OCH-Mac on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainViewController.h"
#import <RevMobAds/RevMobAds.h>

@interface AppDelegate : NSObject <UIApplicationDelegate,RevMobAdsDelegate> {
    UIWindow*				window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
