/*
File: SoundTableViewCell.m
*/

#import "SoundTableViewCell.h"
#import "AlarmInfo.h"
#import "GameUtils.h"

static const NSString* s_strSound[] = {
	@"c-est-l-heure", @"croissants-surprise", @"Reveil-avec-Anissa", @"Reveil-chaud", @"Reveil-militaire",@"Anissa Kate On the Road 66",@"Black Sex Addict",@"Mafiosi",@"Purgatoire",@"Soumission Anale",@"Testament",@"Ultimate French Girls 1",@"Ultimate French Girls 2",@"Ultimate French Girls 3"
};

#pragma mark -
#pragma mark SubviewFrames category

@interface SoundTableViewCell (SubviewFrames)
- (CGRect)_titleLabelFrame;
- (CGRect)_btnPlayFrame;
@end


#pragma mark -
#pragma mark SoundTableViewCell implementation

@implementation SoundTableViewCell

@synthesize index = m_nIndex, strSound, titleLabel, btnPlay;


#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [titleLabel setTextColor:[UIColor darkGrayColor]];
        [titleLabel setHighlightedTextColor:[UIColor whiteColor]];
        titleLabel.minimumScaleFactor =  8.0;
        [self.contentView addSubview:titleLabel];
		
		btnPlay = [[UIButton alloc] initWithFrame:CGRectZero];
		[btnPlay setBackgroundImage:[UIImage imageNamed:@"Play_n.png"] forState:UIControlStateNormal];
		[btnPlay setBackgroundImage:[UIImage imageNamed:@"Play_h.png"] forState:UIControlStateHighlighted];
		[btnPlay addTarget:self action:@selector(actionSoundPlay:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:btnPlay];
		NSLog(@"strsoound===%@",strSound);
		titleLabel.text = strSound;
	}

    return self;
}

- (void)setIndex:(NSUInteger)value {
	m_nIndex = value;
	if(value < DEFAULT_SOUNDCOUNT)
		titleLabel.text = [s_strSound[value] copy];
}

- (void)actionSoundPlay:(id)sel {
	[g_GameUtils playSoundEffect:titleLabel.text Ext:@"wav"];
}

#pragma mark -
#pragma mark Laying out subviews

/*
 To save space, the prep time label disappears during editing.
 */
- (void)layoutSubviews {
    [super layoutSubviews];
	
    [titleLabel setFrame:[self _titleLabelFrame]];
    [btnPlay setFrame:[self _btnPlayFrame]];
	
    if (self.editing) {
        btnPlay.alpha = 0.0;
//		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        btnPlay.alpha = 1.0;
//		self.accessoryType = UITableViewCellAccessoryNone;
    }
}


#define EDITING_INSET       10.0
#define TEXT_LEFT_MARGIN    10.0
#define TEXT_RIGHT_MARGIN   5.0
#define BTN_WIDTH			40.0

/*
 Return the frame of the various subviews -- these are dependent on the editing state of the cell.
 */

- (CGRect)_titleLabelFrame {
	CGSize size = self.contentView.bounds.size;
    if (self.editing) {
        return CGRectMake(EDITING_INSET + TEXT_LEFT_MARGIN, 0.0, size.width - EDITING_INSET - TEXT_RIGHT_MARGIN - TEXT_LEFT_MARGIN, size.height);
    }
	else {
        return CGRectMake(TEXT_LEFT_MARGIN, 0.0, size.width - TEXT_LEFT_MARGIN - TEXT_RIGHT_MARGIN - BTN_WIDTH, size.height);
    }
}

- (CGRect)_btnPlayFrame {
	return CGRectMake(self.contentView.bounds.size.width - BTN_WIDTH - TEXT_RIGHT_MARGIN, 7.0, 30.0, 30.0);
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [titleLabel release];
    [btnPlay release];
    [super dealloc];
}

@end
