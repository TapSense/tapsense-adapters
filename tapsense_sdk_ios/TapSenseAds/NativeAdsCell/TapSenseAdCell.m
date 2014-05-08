//
//  TapSenseAdCell.m
//  Copyright (c) 2013 TapSense. All rights reserved.
//

#import "TapSenseAdCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation TapSenseAdCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString *) reuseIdentifier
{
    return @"TapSenseAdCellIdentifier";
}

+ (CGFloat) cellHeight
{
    return 300.0f;
}


/*
 * This is called by the SDK when a native ad is to be displayed.
 */
- (void) updateWithAdData:(TapSenseNativeAdsData *)adData
{
    //Show sponsred label only when it is a native ad
    [adData loadSponsorNameIntoLabel:self.sponsorName];
    [adData loadImageIntoImageView:self.image];
    [adData loadCallToActionIntoLabel:self.callToAction];
    [adData loadDescriptionIntoLabel:self.description];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.sponsorName = [[UILabel alloc] init];
        self.sponsorName.frame = CGRectMake(10,5,280,20);
        self.sponsorName.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f];
        self.sponsorName.textColor = [UIColor blackColor];
        self.sponsorName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.sponsorName];
        
        self.description = [[UILabel alloc] init];
        self.description.frame = CGRectMake(10,28,280,50);
        self.description.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.0f];
        self.description.numberOfLines = 3;
        self.description.textColor = [UIColor blackColor];
        self.description.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.description];
        

        self.image = [[UIImageView alloc] init];
        self.image.frame = CGRectMake(0, 83, 320, 165);
        [self.contentView addSubview:self.image];
        
        self.callToAction = [[UILabel alloc] init];
        self.callToAction.frame = CGRectMake(215,260,98,28);
        self.callToAction.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
        self.callToAction.textColor = [UIColor blackColor];
        self.callToAction.textAlignment = NSTextAlignmentCenter;
        
        [self.callToAction.layer setBorderWidth:2.0f];
        [self.callToAction.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        self.callToAction.layer.cornerRadius = 4.0f;
        self.callToAction.backgroundColor = [UIColor colorWithRed:.9f green:.9f blue:.9f alpha:1];
        [self.contentView addSubview:self.callToAction];
    
        self.contentView.backgroundColor = [UIColor colorWithRed:.9f green:.9f blue:.9f alpha:1];
    }
    return self;
}

@end
