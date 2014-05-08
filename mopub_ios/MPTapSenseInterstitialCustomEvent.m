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
    NSString *pubId = [info objectForKey:@"pubId"] ? [info objectForKey:@"pubId"] : @"";
    NSString *appId = [info objectForKey:@"appId"] ? [info objectForKey:@"appId"] : @"";
    NSString *secretKey = [info objectForKey:@"secretKey"] ? [info objectForKey:@"secretKey"] : @"";
    BOOL videoOnly = [info objectForKey:@"videoOnly"] ? [[info objectForKey:@"videoOnly"] boolValue] : NO;
    BOOL adFlowOnly = [info objectForKey:@"adFlowOnly"] ? [[info objectForKey:@"adFlowOnly"] boolValue] : NO;
    [TapSenseAds disableGetNextAd];
    [TapSenseAds enableAdFlowOnly:adFlowOnly];
    [TapSenseAds enableVideoOnly:videoOnly];
    
    //change test mode to NO before submitting to App Store.
    [TapSenseAds startInTestMode:YES withPubId:pubId appId:appId secretKey:secretKey];
    [TapSenseAds sharedInstance].delegate = self;
    [[TapSenseAds sharedInstance] requestAd];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    [[TapSenseAds sharedInstance] showAdFromViewController:rootViewController];
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
