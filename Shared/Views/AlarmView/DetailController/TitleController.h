//
//  TitleController.h
//  WakeMe
//
//  Created by OCH-Mac on 2/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RevMobAds/RevMobAds.h>
#import <RevMobAds/RevMobAdsDelegate.h>

@protocol TitleControllerDelegate;

@interface TitleController : UIViewController {
	id <TitleControllerDelegate>	delegate;
	UITextField*	textFiled;

}

//@property(nonatomic,retain)RevMobBanner *banner;

@property (nonatomic, retain) id <TitleControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITextField* textFiled;
@property (nonatomic, retain) NSString* text;

@end

@protocol TitleControllerDelegate
- (void)updateTitleDelegate:(TitleController*)controller String:(NSString*)string;
@end
