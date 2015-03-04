/*
File: SettingInfoTableViewCell.m 
*/

#import "SettingInfoTableViewCell.h"

#pragma mark -
#pragma mark SettingInfoTableViewCell implementation

@implementation SettingInfoTableViewCell

@synthesize imageView, titleLabel, contentLabel;


#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(SettingInfoTableViewCellType)type reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		m_type = type;
        titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.backgroundColor = [UIColor clearColor];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [titleLabel setHighlightedTextColor:[UIColor whiteColor]];
        [self.contentView addSubview:titleLabel];
		
		if(type == SettingInfoTableCellTextType) {
			contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            contentLabel.backgroundColor = [UIColor clearColor];
			[contentLabel setFont:[UIFont systemFontOfSize:12.0]];
			[contentLabel setTextColor:[UIColor darkGrayColor]];
			[contentLabel setHighlightedTextColor:[UIColor whiteColor]];
			[self.contentView addSubview:contentLabel];
		}
		else if(type == SettingInfoTableCellImageType) {
			imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
			imageView.contentMode = UIViewContentModeScaleAspectFit;
			[self.contentView addSubview:imageView];
		}
    }

    return self;
}

- (void)setCellText:(NSString*)strTitle Content:(NSString*)content {
	titleLabel.text = strTitle;
	contentLabel.text = content;
}

- (void)setCellImage:(NSString*)strTitle Image:(UIImage*)img {
	titleLabel.text = strTitle;
	imageView.image = img;
}

#pragma mark -
#pragma mark Laying out subviews

- (void)layoutSubviews {
    [super layoutSubviews];
	
	CGSize size = self.contentView.bounds.size;
    [titleLabel setFrame:CGRectMake(8, 0, size.width / 2 - 20, size.height)];
    [contentLabel setFrame:CGRectMake(size.width / 2 - 10, 10, self.contentView.bounds.size.width / 2 - 50, 14)];
    [imageView setFrame:CGRectMake(size.width / 2 - 10, 3, 50, 50)];
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [imageView release];
    [titleLabel release];
	if(m_type == SettingInfoTableCellTextType)
		[contentLabel release];
//	else if(m_type == SettingInfoTableCellImageType)
//		[imageView release];
    [super dealloc];
}

@end
