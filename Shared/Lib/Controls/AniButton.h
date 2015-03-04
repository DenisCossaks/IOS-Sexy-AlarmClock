//
//  Button.h
//  iIgo
//
//  Created by Kim Kang U on 08/12/16.
//  Copyright 2008 Dalian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AniButton : UIButton {
	UIImage* buttonImage;
	UIImage* focusImage;
	UIImage* defaultImage;
	NSString *buttonText;
	CGFloat fontSize;
	CGSize	textSize;
	NSInteger btnSize;
}

@property (nonatomic, retain) UIImage* buttonImage;
@property (nonatomic, retain) UIImage* focusImage;
@property (nonatomic, retain) UIImage* defaultImage;
@property (nonatomic, retain) NSString *buttonText;

//Initalizer for this object
- (id)initWithTitle:(NSString*) title buttonSize:(NSInteger) nSize frame:(CGRect) rc;
-(void) setupDisplayString;
-(void) setFocus;
-(void) setDefault;
@end
