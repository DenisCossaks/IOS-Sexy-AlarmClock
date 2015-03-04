//
//  ImageSelectView.h
//  WakeMe
//
//  Created by OCH-Mac on 2/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	ButtonState_Off	 = 0,
	ButtonState_On,
} ButtonStates;

@interface SHImageButton : UIImageView {
	NSUInteger	m_nIndex;
	BOOL		m_bSelect;
}

@property (nonatomic) NSUInteger	index;
@property (nonatomic) BOOL			isSelect;

@end


typedef enum {
	ImageTypeOneSelect	 = 0,
	ImageTypeMultiSelect,
} ImageSelectType;

@interface ImageSelectView : UIView <UIGestureRecognizerDelegate>{
	ImageSelectType		m_nType;
	NSMutableArray*		m_arrayButton;
	NSUInteger			m_nSelect;
	BOOL				m_bImageSelect[20];
}

@property (nonatomic) NSUInteger m_nSelect;

- (id)initWithFrame:(CGRect)frame Type:(ImageSelectType)type;
- (NSUInteger)actionDone;

@end
