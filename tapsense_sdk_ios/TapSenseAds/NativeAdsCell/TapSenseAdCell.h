//
//  TapSenseAdCell.h
//  Copyright (c) 2013 TapSense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TapSenseAds/TapSenseNativeAdsManager.h>

@interface TapSenseAdCell : UITableViewCell <TapSenseNativeAdsCell>

@property (retain, nonatomic) IBOutlet UILabel *sponsorName;
@property (strong, nonatomic) IBOutlet UILabel *description;
@property (retain, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *callToAction;

@end
