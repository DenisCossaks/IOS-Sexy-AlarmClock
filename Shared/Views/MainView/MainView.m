//
//  MainView.m
//  WakeMe
//
//  Created by OCH-Mac on 2/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainView.h"
#import "MainViewController.h"

@implementation MainView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	UITouch *touch = touches.anyObject;
//    if( 1 != touches.count ) return;
//	CGPoint point = [touch locationInView:self];
//	if(touch.tapCount == 2)
//		return;
	[viewCntroller actionTouches];
}

- (void)dealloc {
    [super dealloc];
}




@end
