/*
File: AlarmInfoTableViewCell.h
*/


@class AlarmInfo;

@interface AlarmInfoTableViewCell : UITableViewCell {
	NSUInteger	m_nIndex;
	AlarmInfo*	alarmInfo;
	
	UILabel*	indexLabel;
    UILabel*	timeLabel;
    UILabel*	titleLabel;
    UILabel*	periodLabel;
    
	UISwitch*	switchEnable;
}

@property (nonatomic) NSUInteger	index;
@property (nonatomic, retain) AlarmInfo*	alarmInfo;

@property (nonatomic, retain) UILabel*		indexLabel;
@property (nonatomic, retain) UILabel*		timeLabel;
@property (nonatomic, retain) UILabel*		titleLabel;
@property (nonatomic, retain) UILabel*		periodLabel;
@property (nonatomic, retain) UISwitch*		switchEnable;

@end
