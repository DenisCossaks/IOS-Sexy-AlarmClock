/*
File: SoundTableViewCell.h
*/


@class AlarmInfo;

@interface SoundTableViewCell : UITableViewCell {
	NSUInteger	m_nIndex;
	NSString*	strSound;
	
    UILabel*	titleLabel;
	UIButton*	btnPlay;
}

@property (nonatomic) NSUInteger	index;

@property (nonatomic, retain) NSString*		strSound;
@property (nonatomic, retain) UILabel*		titleLabel;
@property (nonatomic, retain) UIButton*		btnPlay;

@end
