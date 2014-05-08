//
//  TSAdUnit.h
//  Copyright (c) 2014 TapSense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TapSenseAdsCloseButtonAttributes.h"
#import "TapSenseNativeAdsData.h"
#import "TapSenseAdsConstants.h"

@interface TSAdUnit : NSObject

@property (nonatomic, strong) NSString *verticalHtml;
@property (nonatomic, strong) NSString *horizontalHtml;
@property (nonatomic, strong) NSString *tapSenseImpressionUrl;
@property (nonatomic, strong) NSString *tapSenseClickUrl;
@property (nonatomic) BOOL canUseInAppDownload;
@property (nonatomic, copy) NSString *finalUrl;
@property (nonatomic) BOOL oneStepDismiss;
@property (nonatomic, strong) TapSenseAdsCloseButtonAttributes* closeButtonAttributes;

//VAST variables
@property (nonatomic, strong) NSArray *impressionUrls;
@property (nonatomic, strong) NSArray *clickTrackingUrls;
@property (nonatomic, strong) NSString *clickThroughUrl;
@property (nonatomic, strong) NSDictionary *trackingEvents;
@property (nonatomic, strong) NSString  *mediaFileUrl;

//Video player parameters
@property (nonatomic) BOOL muted;
@property (nonatomic, strong) NSString *callToActionText;
@property (nonatomic, strong) NSString *advertiserApp;
@property (nonatomic) BOOL showToolBar;
@property (nonatomic, strong) UIColor *ctaTextColor;

//for ad flow
@property (nonatomic) BOOL impressionSent;

//for native ad
@property (nonatomic, strong) TapSenseNativeAdsData *nativeAdData;
@property (nonatomic) kTapSenseAdsActionType actionType;

@end
