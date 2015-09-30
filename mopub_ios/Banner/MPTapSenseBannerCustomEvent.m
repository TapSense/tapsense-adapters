//
//  MPTapSenseBannerCustomEvent.m
//  Copyright (c) 2014 TapSense. All rights reserved.
//

#import "MPTapSenseBannerCustomEvent.h"
#import <TapSenseAds/TapSenseAds.h>

@interface MPTapSenseBannerCustomEvent ()

@property (nonatomic, retain) TapSenseAdView *adBannerView;

@end

@implementation MPTapSenseBannerCustomEvent

#pragma mark - MPBannerCustomEvent methods

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info {
    NSString *adUnitId = [info objectForKey:@"ad_unit_id"] ? [info objectForKey:@"ad_unit_id"] : @"";

    // Remove test mode before going live and submitting to App Store
    [TapSenseAds setTestMode];

    self.adBannerView = [[TapSenseAdView alloc] initWithAdUnitId:adUnitId];
    self.adBannerView.frame = CGRectMake(0, 0, size.width, size.height);
    self.adBannerView.rootViewController = [self.delegate viewControllerForPresentingModalView];
    self.adBannerView.delegate = self;
    [self.adBannerView loadAd];
}

#pragma mark - Lifecycle

- (void)dealloc {
    self.delegate = nil;
    self.adBannerView.delegate = nil;
    self.adBannerView = nil;
}

#pragma mark - TSAdViewDelegate methods

- (void) adViewDidLoadAd:(TapSenseAdView *)view {
    [self.delegate bannerCustomEvent:self didLoadAd:self.adBannerView];
}

- (void) adViewDidFailToLoad:(TapSenseAdView *)view withError:(NSError *)error{
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
}

- (void) adViewWillPresentModalView:(TapSenseAdView *)view {
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void) adViewDidDismissModalView:(TapSenseAdView *)view {
    [self.delegate bannerCustomEventDidFinishAction:self];
}

@end
