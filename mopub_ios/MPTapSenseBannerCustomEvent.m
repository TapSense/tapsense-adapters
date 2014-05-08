//
//  MPTapSenseBannerCustomEvent.m
//  TapSense
//
//  Copyright (c) 2014 TapSense. All rights reserved.
//

#import "MPTapSenseBannerCustomEvent.h"

@interface MPTapSenseBannerCustomEvent ()

@property (nonatomic, retain) TSAdView *adBannerView;

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
    NSString *pubId = [info objectForKey:@"pubId"] ? [info objectForKey:@"pubId"] : @"";
    NSString *appId = [info objectForKey:@"appId"] ? [info objectForKey:@"appId"] : @"";
    NSString *secretKey = [info objectForKey:@"secretKey"] ? [info objectForKey:@"secretKey"] : @"";
    NSString *adUnitId = [info objectForKey:@"adUnitId"] ? [info objectForKey:@"adUnitId"] : @"";
    [TapSenseAds disableGetNextAd];
    
    //change test mode to NO before submitting to App Store.
    [TapSenseAds startInTestMode:YES withPubId:pubId appId:appId secretKey:secretKey];
    self.adBannerView = [[TSAdView alloc] initWithAdUnitId:adUnitId size:size];
    self.adBannerView.rootViewController = [self.delegate viewControllerForPresentingModalView];
    self.adBannerView.delegate = self;
    [self.adBannerView loadAd];
}

#pragma mark -
#pragma mark TSAdViewDelegate methods

- (void) adViewDidLoadAd:(TSAdView *)view
{
    [self.delegate bannerCustomEvent:self didLoadAd:self.adBannerView];
}

- (void) adViewDidFailToLoad:(TSAdView *)view
{
    [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:nil];
}

- (void) adViewWillPresentModalView:(TSAdView *)view
{
    [self.delegate bannerCustomEventWillBeginAction:self];
}

- (void) adViewDidDismissModalView:(TSAdView *)view
{
    [self.delegate bannerCustomEventDidFinishAction:self];
}

- (void) adViewWillLeaveApplication:(TSAdView *)view
{
    [self.delegate bannerCustomEventWillLeaveApplication:self];
}

@end
