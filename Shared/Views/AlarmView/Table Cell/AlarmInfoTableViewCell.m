/*
File: AlarmInfoTableViewCell.m
*/

#import "AlarmInfoTableViewCell.h"
#import "AlarmInfo.h"
#import "GameUtils.h"

#pragma mark -
#pragma mark SubviewFrames category

@interface AlarmInfoTableViewCell (SubviewFrames)
- (CGRect)_indexLabelFrame;
- (CGRect)_timeLabelFrame;
- (CGRect)_titleLabelFrame;
- (CGRect)_periodLabelFrame;
- (CGRect)_switchEnableFrame;
@end


#pragma mark -
#pragma mark AlarmInfoTableViewCell implementation

@implementation AlarmInfoTableViewCell

@synthesize index = m_nIndex, alarmInfo, indexLabel, timeLabel, titleLabel, periodLabel, switchEnable;


#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        indexLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [indexLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
        [indexLabel setTextColor:[UIColor blueColor]];
        indexLabel.backgroundColor = [UIColor clearColor];
        [indexLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:indexLabel];

        timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        timeLabel.backgroundColor = [UIColor clearColor];
        [timeLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
        [timeLabel setTextColor:[UIColor blackColor]];
        [timeLabel setHighlightedTextColor:[UIColor whiteColor]];
		timeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:timeLabel];
		
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setTextColor:[UIColor darkGrayColor]];
        [titleLabel setHighlightedTextColor:[UIColor whiteColor]];
		titleLabel.minimumScaleFactor = 8.0;
        [self.contentView addSubview:titleLabel];
		
        periodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        periodLabel.backgroundColor = [UIColor clearColor];
        [periodLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [periodLabel setTextColor:[UIColor darkGrayColor]];
        [periodLabel setHighlightedTextColor:[UIColor whiteColor]];
		periodLabel.minimumScaleFactor = 8.0;
        [self.contentView addSubview:periodLabel];
		
		switchEnable = [[UISwitch alloc] initWithFrame:CGRectZero];
		[switchEnable setOn:YES animated:NO];
		[switchEnable addTarget:self action:@selector(actionSwtichEnable:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:switchEnable];
		
		indexLabel.text = [NSString stringWithFormat:@"%d", m_nIndex + 1];
		timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", alarmInfo.alarmHour, alarmInfo.alarmMin];
		titleLabel.text = alarmInfo.strMessage;
		periodLabel.text = alarmInfo.strPeriod;
		switchEnable.on = alarmInfo.isEnable;
	}

    return self;
}

#pragma mark -
#pragma mark alarmInfo set accessor

- (void)setAlarmInfo:(AlarmInfo*)newAlarmInfo {
    if (newAlarmInfo != alarmInfo) {
        [alarmInfo release];
        alarmInfo = [newAlarmInfo retain];
	}
	timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", newAlarmInfo.alarmHour, newAlarmInfo.alarmMin];
	titleLabel.text = newAlarmInfo.strMessage;
	periodLabel.text = newAlarmInfo.strPeriod;
	switchEnable.on = newAlarmInfo.isEnable;
}

- (void)setIndex:(NSUInteger)value {
	m_nIndex = value;
	indexLabel.text = [NSString stringWithFormat:@"%d", value + 1];
}

- (void)actionSwtichEnable:(id)sel {
	alarmInfo.isEnable = switchEnable.on;
	[g_GameUtils replaceAlarmInfo:m_nIndex Info:alarmInfo];
}

#pragma mark -
#pragma mark Laying out subviews

/*
 To save space, the prep time label disappears during editing.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
	
    [indexLabel setFrame:[self _indexLabelFrame]];
    [timeLabel setFrame:[self _timeLabelFrame]];
    [titleLabel setFrame:[self _titleLabelFrame]];
    [periodLabel setFrame:[self _periodLabelFrame]];
    [switchEnable setFrame:[self _switchEnableFrame]];
	
    if (self.editing) {
        switchEnable.alpha = 0.0;
//		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        switchEnable.alpha = 1.0;
//		self.accessoryType = UITableViewCellAccessoryNone;
    }
}


#define INDEX_WIDTH			10.0
#define EDITING_INSET       10.0
#define TEXT_LEFT_MARGIN    38.0
#define TEXT_RIGHT_MARGIN   5.0
#define SWITCH_WIDTH		75.0

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */

- (CGRect)_indexLabelFrame {
    if (self.editing) {
        return CGRectMake(EDITING_INSET + 10.0, 0.0, 23.0, self.contentView.bounds.size.height);
    }
	else {
        return CGRectMake(10.0, 0.0, 23.0, self.contentView.bounds.size.height);
    }
}

- (CGRect)_timeLabelFrame {
    if (self.editing) {
        return CGRectMake(TEXT_LEFT_MARGIN + EDITING_INSET, 2.0, 60.0, 27.0);
    }
	else {
        return CGRectMake(TEXT_LEFT_MARGIN, 2.0, 60.0, 27.0);
    }
}

- (CGRect)_titleLabelFrame {
    if (self.editing) {
        return CGRectMake(TEXT_LEFT_MARGIN + EDITING_INSET, 29.0, self.contentView.bounds.size.width - TEXT_LEFT_MARGIN * 2 - EDITING_INSET, 13.0);
    }
	else {
        return CGRectMake(TEXT_LEFT_MARGIN, 29.0, self.contentView.bounds.size.width - TEXT_LEFT_MARGIN * 2 - SWITCH_WIDTH, 13.0);
    }
}

- (CGRect)_periodLabelFrame {
    if (self.editing) {
        return CGRectMake(TEXT_LEFT_MARGIN + EDITING_INSET, 45.0, self.contentView.bounds.size.width - TEXT_LEFT_MARGIN * 2 - EDITING_INSET, 17.0);
    }
	else {
        return CGRectMake(TEXT_LEFT_MARGIN, 45.0, self.contentView.bounds.size.width - TEXT_LEFT_MARGIN * 2 - SWITCH_WIDTH, 17.0);
    }
}

- (CGRect)_switchEnableFrame {
	return CGRectMake(self.contentView.bounds.size.width - SWITCH_WIDTH - TEXT_RIGHT_MARGIN, 18.0, 94.0, 27.0);
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [alarmInfo release];
    [indexLabel release];
    [timeLabel release];
    [titleLabel release];
    [periodLabel release];
    [switchEnable release];
    [super dealloc];
}

@end
