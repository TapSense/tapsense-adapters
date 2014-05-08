//
//  TapSenseAds.h
//  Copyright (c) 2014 TapSense Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TapSenseAdsDelegate;

@interface TapSenseAds : NSObject

/* NOTE: Make sure to set to nil when releasing TapSenseAds */
@property (nonatomic, weak) id <TapSenseAdsDelegate> delegate;

/*
 * Test Mode guarantees that you receive an ad on every request.
 */
+ (void)startInTestMode:(BOOL) testMode
              withPubId:(NSString *) pubId
                  appId:(NSString *) appId
              secretKey:(NSString *) secret;

/* Get the TapSenseAds singleton */
+ (TapSenseAds *)sharedInstance;

/*
 * Show the ad from the specified view controller.
 * Returns NO instantly if the ad cannot be shown (refer to isReady for details)
 * This method also preloads the next ad regardless of the result of the display.
 * Implement TSAdDidFailToShow delegate to get error details.
 */
- (BOOL)showAdFromViewController:(UIViewController*)viewController;

/*
 * Checks if it is okay to display the ad.
 * isReady returns NO if any of the following is true:
 * a) Internet is not active        b) TapSense did not return an ad
 * c) Ad is still being downloaded  d) Preloaded ad's orientation is different from current orientation
 */
- (BOOL)isReady;

/*
 * Method to request an ad without displaying it. This is called automatically when you call 
 * +[TapSenseAds start] and -showAdFromViewController.
 * You may implement the -tapSenseDidLoadAd and -tapSenseDidFailToLoadAdWithError
 * delegate methods for the callback.
 * Returns NO instantly if the internet is down or another request is in progress.
 * This method does not automatically retry if it fails.
 */
- (BOOL)requestAd;

+ (void) enableDebugLog: (BOOL) value;
+ (NSString *) getSDKVersion;

/*
 * Advanced (Optional) API for interstitial ads
 */
+ (void) disableGetNextAd;
+ (void) enableVideoOnly: (BOOL) value;
+ (void) enableAdFlowOnly: (BOOL) value;
+ (void) setInterstitialAdUnitId: (NSString *) kAdUnitId;

@end

/*
 * Note: All delegate methods are optional.
 * Implement them only if you want more control over TapSenseAds life cycle.
 */
@protocol TapSenseAdsDelegate <NSObject>
@optional

/*
 * Called when the ad (un)successfully loads its ad content.
 */
- (void)tapSenseDidLoadAd;
- (void)tapSenseDidFailToLoadAdWithError:(NSError*)error;

/*
 * Called when the ad is appearing or disappearing. These might
 * be a good time to pause / resume your app.
 */
- (void)tapSenseAdWillAppear;
- (void)tapSenseAdDidDisappear;

@end




