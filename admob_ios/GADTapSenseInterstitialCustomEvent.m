//
//  GADTapSenseInterstitialCustomEvent.m
//  TapSense
//
//  Copyright (c) 2014 TapSense, Inc. All rights reserved.
//

#import "GADTapSenseInterstitialCustomEvent.h"

@implementation GADTapSenseInterstitialCustomEvent

@synthesize delegate = delegate_;

#pragma mark - GADCustomEventInterstitial Protocol Methods

- (void)requestInterstitialAdWithParameter:(NSString *)serverParameter
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

- (void)presentFromRootViewController:(UIViewController *)rootViewController;
{
    [[TapSenseAds sharedInstance] showAdFromViewController:rootViewController];
}

- (void)dealloc
{
    self.delegate = nil;
    [TapSenseAds sharedInstance].delegate = nil;
}

#pragma mark - TapSenseAdsDelegate

- (void) tapSenseDidLoadAd
{
    [self.delegate customEventInterstitial:self didReceiveAd:nil];
}

- (void) tapSenseDidFailToLoadAdWithError:(NSError *)error
{
    [self.delegate customEventInterstitial:self didFailAd:error];
}

- (void) tapSenseAdWillAppear
{
    [self.delegate customEventInterstitialWillPresent:self];
}

- (void) tapSenseAdDidDisappear
{
    [self.delegate customEventInterstitialWillDismiss:self];
    [self.delegate customEventInterstitialDidDismiss:self];
}

@end
