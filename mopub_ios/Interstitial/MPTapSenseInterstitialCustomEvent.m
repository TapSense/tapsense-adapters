//
//  MPTapSenseInterstitialCustomEvent.m
//  Copyright (c) 2014 TapSense, Inc. All rights reserved.
//

#import "MPTapSenseInterstitialCustomEvent.h"
#import <TapSenseAds/TapSenseAds.h>

@interface MPTapSenseInterstitialCustomEvent ()

@property (nonatomic, retain) TapSenseInterstitial *interstitial;

@end


@implementation MPTapSenseInterstitialCustomEvent

#pragma mark - MPInterstitialCustomEvent Subclass Methods

- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info {
    NSString *adUnitId = [info objectForKey:@"ad_unit_id"] ? [info objectForKey:@"ad_unit_id"] : @"";

    // Remove test mode before going live and submitting to App Store
    [TapSenseAds setTestMode];

    self.interstitial = [[TapSenseInterstitial alloc] initWithAdUnitId:adUnitId shouldAutoRequestAd:NO];
    self.interstitial.delegate = self;
    [self.interstitial requestAd];
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController {
    if (self.interstitial.isReady) {
        [self.interstitial showAdFromViewController:rootViewController];
    }
}

#pragma mark - Lifecycle

- (void)dealloc {
    self.delegate = nil;
    self.interstitial.delegate = nil;
    self.interstitial = nil;
}

#pragma mark - TapSenseInterstitialDelegate methods

- (void)interstitialDidLoad:(TapSenseInterstitial*)interstitial {
    [self.delegate interstitialCustomEvent:self didLoadAd:self];
}

- (void)interstitialDidFailToLoad:(TapSenseInterstitial*)interstitial
                        withError:(NSError*)error {
    [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
}

- (void)interstitialWillAppear:(TapSenseInterstitial*)interstitial {
    [self.delegate interstitialCustomEventWillAppear:self];
    [self.delegate interstitialCustomEventDidAppear:self];
}

- (void)interstitialDidDisappear:(TapSenseInterstitial*)interstitial {
    [self.delegate interstitialCustomEventWillDisappear:self];
    [self.delegate interstitialCustomEventDidDisappear:self];
}

@end
