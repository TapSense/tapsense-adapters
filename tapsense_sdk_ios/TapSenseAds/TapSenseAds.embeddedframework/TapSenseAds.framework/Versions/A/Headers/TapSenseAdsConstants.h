//
//  TapSenseAdsConstants.h
//  Copyright (c) 2014 TapSense Inc. All rights reserved.
//

#define TS_IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define TS_AD_FLOW_BACKGROUND_COLOR [UIColor colorWithRed:.92578125 green:.92578125 blue:.92578125 alpha:1];

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    OPEN_URL = 0,
    IN_APP_DOWNLOAD = 1,
    REDIRECT = 2,
    WEB_PAGE = 3,
    VIDEO = 4
} kTapSenseAdsActionType;

typedef enum{
    TS_INTERSTITIAL = 0,
    TS_NATIVE = 1,
    TS_BANNER = 2,
    TS_VIDEO = 3,
    TS_AD_FLOW = 4
} kTapSenseAdsAdType;


extern NSString * const kTapSenseAdsGitHash;
extern NSString * const kTapSenseAdsSDKVersion;

// Internet status constants
extern NSString * const kTapSenseAdsWifiEnabled;
extern NSString * const kTapSenseAdsCelluarEnabled;
extern NSString * const kTapSenseAdsInternetDisabled;
extern NSString * const kTapSenseAdsRequestUrlHost;
extern NSString * const kTapSenseAdsRequestUrlScheme;
extern NSString * const kTapSenseAdsRequestUrlPath;
extern NSString * const kTapSenseAdsRequestUrlParameters;
extern int const kTapSenseAdsPendingRequestRefreshTimeInSeconds;
extern NSString * const kTapSenseAdsTestPubId;
extern NSString * const kTapSenseAdsVersionDelimiter;

//Response Constants
extern NSString * const kTapSenseAdsTimeStampMarker;
extern NSString * const kTapSenseAdsStatusValueMarker;
extern NSString * const kTapSenseAdsStatusOkMarker;
extern NSString * const kTapSenseAdsCountAdUnitsMarker;
extern NSString * const kTapSenseAdsReturnedWidthMarker;
extern NSString * const kTapSenseAdsReturnedHeightMarker;
extern NSString * const kTapSenseAdsImpressionUrlMarker;
extern NSString * const kTapSenseAdsSleepTimeMarker;
extern NSString * const kTapSenseAdsStatusMarker;
extern NSString * const kTapSenseAdsAdUnitsMarker;
extern NSString * const kTapSenseAdsVerticalHtmlMarker;
extern NSString * const kTapSenseAdsHorizontalHtmlMarker;
extern NSString * const kTapSenseAdsAdTypeMarker;
extern NSString * const kTapSenseAdsAdvertiserAppMarker;
extern NSString * const kTapSenseAdsClickUrlMarker;
extern NSString * const kTapSenseAdsImageUrlMarker;
extern NSString * const kTapSenseAdsUseInAppDownloadMarker;
extern NSString * const kTapSenseAdsFinalUrlMarker;
extern NSString * const kTapSenseAdsVastMarker;
extern NSString * const kTapSenseAdsOneStepDismissMarker;
extern NSString * const kTapSenseAdsCallToActionMarker;
extern NSString * const kTapSenseAdsMuteMarker;
extern NSString * const kTapSenseAdsNativeHtmlMarker;
extern NSString * const kTapSenseAdsShowToolBarMarker;
extern NSString * const kTapSenseAdsCtaTextColorMarker;
extern NSString * const kTapSenseAdsAdapterNameMarker;
extern NSString * const kTapSenseAdsAdapaterDataMarker;
extern NSString * const kTapSenseAdsExpireTimeMarker;
extern NSString * const kTapSenseAdsFallBackUrlMarker;
extern NSString * const kTapSenseAdsNextRequestMarker;

extern NSString * const kTapSenseAdsCloseButtonMarker;
extern NSString * const kTapSenseAdsCloseButtonWidthMarker;
extern NSString * const kTapSenseAdsCloseButtonHeightMarker;
extern NSString * const kTapSenseAdsCloseButtonXMarker;
extern NSString * const kTapSenseAdsCloseButtonYMarker;
extern NSString * const kTapSenseAdsCloseButtonWaitTimeMarker;
extern NSString * const kTapSenseAdsCloseButtonImageUrlMarker;

extern NSTimeInterval const kTapSenseAdsDefaultRefreshInterval;
extern float const kTapSenseAdsRotationDelayInSeconds;
extern NSString * const kTapSenseAdsDefaultInterstitialAdUnitId;

//Identifier Constants
extern NSString * const kTapSenseAdsSha1ColonMacTag;
extern NSString * const kTapSenseAdsOdinTag;
extern NSString * const kTapSenseAdsAdvertiserIdTag;
extern NSString * const kTapSenseAdsAdvertiserIdStatusTag;

extern int const kTapSenseAdsCloseButtonWidthDefault;
extern int const kTapSenseAdsCloseButtonHeightDefault;
extern int const kTapSenseAdsCloseButtonWidthDefaultIPad;
extern int const kTapSenseAdsCloseButtonHeightDefaultIPad;
extern int const kTapSenseAdsCloseButtonXDefault;
extern int const kTapSenseAdsCloseButtonYDefault;
extern int const kTapSenseAdsCloseButtonWaitTimeDefault;
extern NSString * const kTapSenseAdsResourceBundleName;
extern NSString * const kTapSenseAdsCloseButtonImageNameIPhone;
extern NSString * const kTapSenseAdsCloseButtonImageNameIPad;
extern NSString * const kTapSenseAdsCloseButtonImageUrlDefault;
extern NSString * const kTapSenseAdsCallToActionDefault;
extern float const kTapSenseAdsCtaBorderWidth;
extern float const kTapSenseAdsCtaCornerRadius;
extern NSString * const kTapSenseAdsCtaDefaultColorHex;

extern NSUInteger const kTapSenseAdsCacheSizeInBytes;

extern NSString * const kTapSenseAdsNativeParamsRequestUrlPath;

//Response Constants
extern NSString * const kTapSenseAdsActionTypeMarker;
extern NSString * const kTapSenseAdsWebPageActionMarker;
extern NSString * const kTapSenseAdsInAppDownloadActionMarker;
extern NSString * const kTapSenseAdsVideoActionMarker;
extern NSString * const kTapSenseAdsSponsorNameMarker;
extern NSString * const kTapSenseAdsDescriptionMarker;
extern NSString * const kTapSenseAdsTitleMarker;
extern NSString * const kTapSenseAdsHtmlMarker;
extern NSString * const kTapSenseAdsElementsMarker;
extern NSString * const kTapSenseAdsNativeConfigMarker;
extern NSString * const kTapSenseAdsNativeInStreamHtmlMarker;
extern NSString * const kTapSenseAdsNativeInStreamMarker;
extern NSString * const kTapSenseAdsTsAdTypeMarker;
extern NSString * const kTapSenseAdsSeparationMarker;
extern NSString * const kTapSenseAdsStartIndexMarker;
extern NSString * const kTapSenseAdsNativeStartParamsMarker;

extern int const kTapSenseAdsMaxRequestTimeOut;
extern float const kTapSenseAdsTableRefreshDelay;
extern int const kTapSenseAdsBatchRequestSize;
extern int const kTapSenseAdsDefaultSeparation;
extern int const kTapSenseAdsDefaultStartIndex;
extern float const kTapSenseAdsDefaultCellHeight;

extern NSString * const kTapSenseAdsHtmlCellReuseIdentifier;


