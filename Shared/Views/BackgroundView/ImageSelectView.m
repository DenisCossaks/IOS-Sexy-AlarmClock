//
//  ImageSelectView.m
//  WakeMe
//
//  Created by OCH-Mac on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ImageSelectView.h"
#import "GameUtils.h"

#define DEFAULT_IMAGE_COUNT		14
#define ROW_COUNT				4

#pragma mark SHImageButton

@implementation SHImageButton

@synthesize index = m_nIndex, isSelect = m_bSelect;

- (void)setIndex:(NSUInteger)nIndex {
	m_nIndex = nIndex;
	UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"Back%d.jpg", nIndex]];
	[self setBackgroundImage:image forState:UIControlStateNormal];
	[image release];
}

@end


#pragma mark ImageSelectView

@implementation ImageSelectView

@synthesize m_nSelect;

- (id)initWithFrame:(CGRect)frame Type:(ImageSelectType)type {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		m_nType = type;
		m_nSelect = 0;
		m_arrayButton = [[NSMutableArray alloc] init];
		int i;
		for(i = 0; i < DEFAULT_IMAGE_COUNT; i++) {
			int row = i / 4;
			int col = i % 4;
//			UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//			btn.frame = CGRectMake(frame.size.width / 4 * col + 10, 75 * row + 10, 55, 55);
//            
//			UIImage* thumbImage = [UIImage imageNamed:[NSString stringWithFormat:@"thumb%d.JPG", i]];
////			UIImage* thumbImage = [GameUtils getThumbnailImage:image WithSize:btn.frame.size];
//			[btn setImage:thumbImage forState:UIControlStateNormal];
//			[thumbImage release];
////			[image release];

			
            UIImageView * btn = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width / 4 * col + 10, 75 * row + 10, 55, 55)];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"thumb%d.JPG", i]]];
//			[btn addTarget:self action:@selector(actionBtnSelect:) forControlEvents:UIControlEventTouchUpInside];
            btn.userInteractionEnabled = YES;

            
            UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
            tapGesture.delegate = self;
            tapGesture.numberOfTapsRequired = 1;
            [btn addGestureRecognizer:tapGesture];

            
            
			[self addSubview:btn];
			[m_arrayButton addObject:btn];
			
			m_nSelect = 0;
			m_bImageSelect[i] = NO;
		}
		for(i = 0; i < g_nImageSelectCount; i++)
			m_bImageSelect[g_nImageSelect[i]] = YES;
        
		CGRect rect = frame;
		rect.size.height = 75 * DEFAULT_IMAGE_COUNT / 4 + 30;
		self.frame = rect;
//		self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (NSUInteger)actionDone {
	int nCount = 0;
	for(int i = 0; i < 20; i++) {
		if(m_bImageSelect[i]) {
			g_nImageSelect[nCount] = i;
			nCount++;
		}
	}
	return nCount;
}

- (void) tapDetected:(UITapGestureRecognizer*) gesture
{
    UIImageView * sender = (UIImageView*) gesture.view;

    
	int i = 0;
	for(SHImageButton* btn in m_arrayButton) {
		if(sender == btn) {
			if(m_nType == ImageTypeOneSelect) {
				m_nSelect = i;
			}
			else {
				m_bImageSelect[i] = !m_bImageSelect[i];
			}
			[self setNeedsDisplay];
			return;
		}
		i++;
	}
    
}


- (void)actionBtnSelect:(id)sender {
	int i = 0;
	for(SHImageButton* btn in m_arrayButton) {
		if(sender == btn) {
			if(m_nType == ImageTypeOneSelect) {
				m_nSelect = i;
			}
			else {
				m_bImageSelect[i] = !m_bImageSelect[i];
			}
			[self setNeedsDisplay];
			return;
		}
		i++;
	}
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	CGContextSetRGBFillColor(contextRef, 1.0, 1.0, 1.0, 1.0);
	CGContextFillRect(contextRef, rect);
	if(m_nType == ImageTypeOneSelect) {
		UIButton* btn = [m_arrayButton objectAtIndex:m_nSelect];
		CGRect rt = btn.frame;
		rt = CGRectMake(rt.origin.x - 3, rt.origin.y - 3, rt.size.width + 6, rt.size.height + 6);
		CGContextSetRGBFillColor(contextRef, 0.0, 0.0, 1.0, 0.7);
		CGContextFillRect(contextRef, rt);
	}
	else {
		int i = 0;
		for(UIButton* btn in m_arrayButton) {
			if(m_bImageSelect[i]) {
				CGRect rt = btn.frame;
				rt = CGRectMake(rt.origin.x - 3, rt.origin.y - 3, rt.size.width + 6, rt.size.height + 6);
				CGContextSetRGBFillColor(contextRef, 0.0, 0.0, 1.0, 0.7);
				CGContextFillRect(contextRef, rt);
			}
			i++;
		}
	}
}

- (void)dealloc {
	[m_arrayButton removeAllObjects];
    [super dealloc];
}

@end
