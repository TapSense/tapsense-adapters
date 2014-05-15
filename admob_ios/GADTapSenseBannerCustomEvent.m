//
//  GADTapSenseBannerCustomEvent.m
//  TapSense
//
//  Copyright (c) 2014 TapSense. All rights reserved.
//

#import "GADTapSenseBannerCustomEvent.h"

@interface GADTapSenseBannerCustomEvent ()

@property (nonatomic, retain) TSAdView *adBannerView;

@end


@implementation GADTapSenseBannerCustomEvent

@synthesize delegate = delegate_;


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
    self.delegate = nil;
    self.adBannerView.delegate = nil;
    self.adBannerView = nil;
}

- (void)requestBannerAd:(GADAdSize)adSize
              parameter:(NSString *)serverParameter
                  label:(NSString *)serverLabel
                request:(GADCustomEventRequest *)request
{
    NSError *error = nil;
    NSDictionary *info =
    [NSJSONSerialization JSONObjectWithData: [serverParameter dataUsingEncoding:NSUTF8StringEncoding]
                                    options: NSJSONReadingMutableContainers
                                      error: &error];
    NSString *pubId = [info objectForKey:@"pubId"] ? [info objectForKey:@"pubId"] : @"";
    NSString *appId = [info objectForKey:@"appId"] ? [info objectForKey:@"appId"] : @"";
    NSString *secretKey = [info objectForKey:@"secretKey"] ? [info objectForKey:@"secretKey"] : @"";
    NSString *adUnitId = [info objectForKey:@"adUnitId"] ? [info objectForKey:@"adUnitId"] : @"";
    [TapSenseAds disableGetNextAd];

    //change test mode to NO before submitting to App Store.
    [TapSenseAds startInTestMode:YES withPubId:pubId appId:appId secretKey:secretKey];
    self.adBannerView = [[TSAdView alloc] initWithAdUnitId:adUnitId size:adSize.size];
    self.adBannerView.rootViewController = self.delegate.viewControllerForPresentingModalView;
    self.adBannerView.delegate = self;
    [self.adBannerView loadAd];
}

#pragma mark -
#pragma mark TSAdViewDelegate methods

- (void) adViewDidLoadAd:(TSAdView *)view
{
    [self.delegate customEventBanner:self didReceiveAd:view];
}

- (void) adViewDidFailToLoad:(TSAdView *)view
{
    [self.delegate customEventBanner:self didFailAd:nil];
}

- (void) adViewWillPresentModalView:(TSAdView *)view
{
    [self.delegate customEventBannerWillPresentModal:self];
}

- (void) adViewDidDismissModalView:(TSAdView *)view
{
    [self.delegate customEventBannerWillDismissModal:self];
    [self.delegate customEventBannerDidDismissModal:self];
}

@end
