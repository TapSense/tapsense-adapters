//
//  GADTapSenseBannerCustomEvent.m
//  Copyright (c) 2014 TapSense. All rights reserved.
//

#import "GADTapSenseBannerCustomEvent.h"
#import <TapSenseAds/TapSenseAds.h>

@interface GADTapSenseBannerCustomEvent ()

@property (nonatomic, retain) TapSenseAdView *adBannerView;

@end


@implementation GADTapSenseBannerCustomEvent

@synthesize delegate = _delegate;

#pragma mark - GADCustomEventBanner Protocol Methods

- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)request {
    NSError *error = nil;
    NSDictionary *info =
    [NSJSONSerialization JSONObjectWithData: [serverParameter dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &error];
    NSString *adUnitId = [info objectForKey:@"ad_unit_id"] ? [info objectForKey:@"ad_unit_id"] : @"";

    // Remove test mode before going live and submitting to App Store
    [TapSenseAds setTestMode];

    self.adBannerView = [[TapSenseAdView alloc] initWithAdUnitId:adUnitId];
    self.adBannerView.frame = CGRectMake(0, 0, adSize.size.width, adSize.size.height);
    self.adBannerView.rootViewController = self.delegate.viewControllerForPresentingModalView;
    self.adBannerView.delegate = self;
    [self.adBannerView loadAd];
}

#pragma mark - Lifecycle

- (void)dealloc {
    self.delegate = nil;
    self.adBannerView.delegate = nil;
    self.adBannerView = nil;
}

#pragma mark - TapSenseAdViewDelegate methods

- (void) adViewDidLoadAd:(TapSenseAdView *)view {
    [self.delegate customEventBanner:self didReceiveAd:view];
}

- (void) adViewDidFailToLoad:(TapSenseAdView *)view withError:(NSError *)error{
    [self.delegate customEventBanner:self didFailAd:error];
}

- (void) adViewWillPresentModalView:(TapSenseAdView *)view {
    [self.delegate customEventBannerWillPresentModal:self];
}

- (void) adViewDidDismissModalView:(TapSenseAdView *)view {
    [self.delegate customEventBannerDidDismissModal:self];
}

@end
