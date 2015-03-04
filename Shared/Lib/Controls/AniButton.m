//
//  Button.m
//
//  Created by OCH on 08/12/16.
//  Copyright 2008 Dalian. All rights reserved.
//

#import "AniButton.h"


@implementation AniButton

@synthesize buttonImage;
@synthesize focusImage;
@synthesize defaultImage;
@synthesize buttonText;

- (id)initWithTitle:(NSString*) title buttonSize:(NSInteger) nSize frame:(CGRect) frame{
	btnSize = nSize;
	// Retrieve the image for the view and determine its size
	NSString* imgName, *focusName;
	if(btnSize == 1)
	{
		imgName = @"BtnL1.png";	focusName = @"BtnL2.png";
	}
	else if(btnSize == 2)
	{
		imgName = @"BtnN1.png";	focusName = @"BtnN2.png";
	}
	else
	{
		imgName = @"BtnS1.png";	focusName = @"BtnS2.png";
	}
	UIImage *image = [UIImage imageNamed:imgName];
	focusImage = [UIImage imageNamed:focusName];
	defaultImage = image;
	//CGRect frame = CGRectMake(0, 0, image.size.width, image.size.height);
	buttonText =  NSLocalizedStringFromTable(title, @"English", @"");	
	
	// Set self's frame to encompass the image
	if (self = [self initWithFrame:frame]) {
		
		[self setBackgroundImage:focusImage forState:UIControlStateHighlighted];
		self.opaque = NO;
		buttonImage = image;
		[self setupDisplayString];
	}
	return self;
}


- (void)dealloc {
//	[buttonImage release];
//	[focusImage release];
	[super dealloc];
}

#define STRING_INDENT 10

- (void)drawRect:(CGRect)rect {
	
	// Draw the placard at 0, 0
	[buttonImage drawAtPoint:(CGPointMake(0.0, 0.0))];
	
	/*
	 Draw the current display string.
	 Typically you would use a UILabel, but this example serves to illustrate the UIKit extensions to NSString.
	 The text is drawn center of the view twice - first slightly offset in black, then in white -- to give an embossed appearance.
	 The size of the font and text are calculated in setupNextDisplayString.
	 */
	
	// Find point at which to draw the string so it will be in the center of the view
	CGFloat x = self.bounds.size.width/2 - textSize.width/2;
	CGFloat y = self.bounds.size.height/2 - textSize.height/2;
	CGPoint point;
	
	// Get the font of the appropriate size
	UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
	if(self.enabled)
		[[UIColor colorWithRed:126 /255.0 green:220 /255.0 blue:255 /255.0 alpha:0.75] set];
	else
		[[UIColor colorWithRed:170 /255.0 green:170 /255.0 blue:170 /255.0 alpha:0.75] set];
		
	point = CGPointMake(x, y + 0.5);
	[buttonText drawAtPoint:point forWidth:(self.bounds.size.width-STRING_INDENT) withFont:font fontSize:fontSize lineBreakMode:NSLineBreakByTruncatingMiddle baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
	
}

-(void) setFocus {
	buttonImage = focusImage;
	[self setNeedsDisplay];
}

-(void) setDefault {
	buttonImage = defaultImage;
}

- (void)setupDisplayString {
	int nFontSize = 18;
	if(btnSize == 1)
		nFontSize = 26;
	else if(btnSize == 2)
		nFontSize = 24;

	UIFont *font = [UIFont boldSystemFontOfSize:nFontSize];
	// Precalculate size of text and size of font so that text fits inside placard
	textSize = [buttonText sizeWithFont:font minFontSize:9.0 actualFontSize:&fontSize forWidth:(self.bounds.size.width-STRING_INDENT) lineBreakMode:NSLineBreakByTruncatingMiddle];
	[self setNeedsDisplay];
}


@end
