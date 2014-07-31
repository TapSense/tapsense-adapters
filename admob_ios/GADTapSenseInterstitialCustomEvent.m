//
//  GADTapSenseInterstitialCustomEvent.m
//  Copyright (c) 2014 TapSense, Inc. All rights reserved.
//

#import "GADTapSenseInterstitialCustomEvent.h"
#import <TapSenseAds/TapSenseAds.h>

@interface GADTapSenseInterstitialCustomEvent ()

@property (nonatomic, retain) TapSenseInterstitial *interstitial;

@end


@implementation GADTapSenseInterstitialCustomEvent

@synthesize delegate = delegate_;

- (void)dealloc {
    self.delegate = nil;
    self.interstitial.delegate = nil;
    self.interstitial = nil;
}

#pragma mark - GADCustomEventInterstitial Protocol Methods

- (void)requestInterstitialAdWithParameter:(NSString *)serverParameter
                                     label:(NSString *)serverLabel
                                   request:(GADCustomEventRequest *)request {
    NSError *error = nil;
    NSDictionary *info =
    [NSJSONSerialization JSONObjectWithData: [serverParameter dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &error];
    NSString *adUnitId = [info objectForKey:@"adUnitId"] ? [info objectForKey:@"adUnitId"] : @"";

    // Remove test mode before going live and submitting to App Store
    [TapSenseAds setTestMode];

    self.interstitial = [[TapSenseInterstitial alloc] initWithAdUnitId:adUnitId shouldAutoRequestAd:NO];
    self.interstitial.delegate = self;
    [self.interstitial requestAd];
}

- (void)presentFromRootViewController:(UIViewController *)rootViewController; {
    if (self.interstitial.isReady) {
        [self.interstitial showAdFromViewController:rootViewController];
    }
}

#pragma mark - TapSenseInterstitialDelegate methods

- (void)interstitialDidLoad:(TapSenseInterstitial*)interstitial {
    [self.delegate customEventInterstitial:self didReceiveAd:nil];
}

- (void)interstitialDidFailToLoad:(TapSenseInterstitial*)interstitial
                        withError:(NSError*)error {
    [self.delegate customEventInterstitial:self didFailAd:error];
}

- (void)interstitialWillAppear:(TapSenseInterstitial*)interstitial {
    [self.delegate customEventInterstitialWillPresent:self];
}

- (void)interstitialDidDisappear:(TapSenseInterstitial*)interstitial {
    [self.delegate customEventInterstitialWillDismiss:self];
    [self.delegate customEventInterstitialDidDismiss:self];
}

@end
