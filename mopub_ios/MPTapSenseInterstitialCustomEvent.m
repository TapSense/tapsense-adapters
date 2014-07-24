//
//  MPTapSenseInterstitialCustomEvent.m
//  TapSense
//
//  Copyright (c) 2014 TapSense, Inc. All rights reserved.
//

#import "MPTapSenseInterstitialCustomEvent.h"

@implementation MPTapSenseInterstitialCustomEvent

#pragma mark - MPInterstitialCustomEvent Subclass Methods

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
//
//    //change test mode to NO before submitting to App Store.
//    [TapSenseAds sharedInstance].delegate = self;
//    [[TapSenseAds sharedInstance] requestAd];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
//    [[TapSenseAds sharedInstance] showAdFromViewController:rootViewController];
}

#pragma mark - TapSenseAdsDelegate

- (void) tapSenseDidLoadAd
{
    [self.delegate interstitialCustomEvent:self didLoadAd:self];
}

- (void) tapSenseDidFailToLoadAdWithError:(NSError *)error
{
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

- (void) tapSenseAdWillAppear
{
    [self.delegate interstitialCustomEventWillAppear:self];
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void) tapSenseAdDidDisappear
{
    [self.delegate interstitialCustomEventWillDisappear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
}

@end
