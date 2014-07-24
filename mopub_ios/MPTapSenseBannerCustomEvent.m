//
//  MPTapSenseBannerCustomEvent.m
//  TapSense
//
//  Copyright (c) 2014 TapSense. All rights reserved.
//

#import "MPTapSenseBannerCustomEvent.h"
#import <TapSenseAds/TapSenseAds.h>

@interface MPTapSenseBannerCustomEvent ()

@property (nonatomic, retain) TapSenseAdView *adBannerView;

@end


@implementation MPTapSenseBannerCustomEvent

- (id)init
{
    self = [super init];
    if (self)
    {
        //ad view is initalized in request
    }
    return self;
}

- (void)dealloc
{
    self.adBannerView.delegate = nil;
    self.adBannerView = nil;
}

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info
{

    NSString *adUnitId = [info objectForKey:@"adUnitId"] ? [info objectForKey:@"adUnitId"] : @"";
    [TapSenseAds setTestMode];

    [TapSenseAds enableDebugLog:YES];
    
    //change test mode to NO before submitting to App Store.
    self.adBannerView = [[TapSenseAdView alloc] initWithAdUnitId:adUnitId];
    self.adBannerView.frame = CGRectMake(0, 0, size.width, size.height);
    self.adBannerView.rootViewController = [self.delegate viewControllerForPresentingModalView];
    self.adBannerView.delegate = self;
    [self.adBannerView loadAd];
}

#pragma mark -
#pragma mark TSAdViewDelegate methods

- (void) adViewDidLoadAd:(TapSenseAdView *)view
{
    [self.delegate bannerCustomEvent:self didLoadAd:self.adBannerView];
}

- (void) adViewDidFailToLoad:(TapSenseAdView *)view
{
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void) adViewWillPresentModalView:(TapSenseAdView *)view
{
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void) adViewDidDismissModalView:(TapSenseAdView *)view
{
    [self.delegate bannerCustomEventDidFinishAction:self];
}

- (void) adViewWillLeaveApplication:(TapSenseAdView *)view
{
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

@end
