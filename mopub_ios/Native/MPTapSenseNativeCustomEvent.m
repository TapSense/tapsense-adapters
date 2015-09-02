//
//  MPTapSenseNativeCustomEvent.m
//  TapSense
//
//  Copyright (c) 2015 TapSense. All rights reserved.
//

#import <TapSenseAds/TapSenseAds.h>
#import <TapSenseAds/TSNativeAd.h>
#import <TapSenseAds/TSErrorCode.h>
#import "MPTapSenseNativeCustomEvent.h"
#import "MPTapSenseNativeAdAdapter.h"
#import "MPNativeAd.h"
#import "MPLogging.h"
#import "MPNativeAdError.h"
#import "MPNativeAdConstants.h"
#import "MPNativeAdUtils.h"

@interface MPTapSenseNativeCustomEvent () <TSNativeAdDelegate>

@property (nonatomic, strong) TSNativeAd *tsNativeAd;

@end

@implementation MPTapSenseNativeCustomEvent

- (void)requestAdWithCustomEventInfo:(NSDictionary *)info
{
    //TODO: Remove test mode before going live and submitting to App Store
    [TapSenseAds setTestMode];
    
    NSString *adUnitId = [info objectForKey:@"adUnitId"];

    if ([adUnitId length]){
        self.tsNativeAd = [[TSNativeAd alloc] initWithAdUnitId:adUnitId];
        self.tsNativeAd.delegate = self;
        [self.tsNativeAd loadAd];
    } else {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:MPNativeAdNSErrorForInvalidAdServerResponse(@"Invalid TapSense ad unit ID")];
    }
}

#pragma mark - IMNativeDelegate

- (void)nativeAdDidFinishLoading:(TSNativeAd *)nativeAd {
    MPTapSenseNativeAdAdapter *adAdapter = [[MPTapSenseNativeAdAdapter alloc] initWithTapSenseNativeAd:nativeAd];
    MPNativeAd *interfaceAd = [[MPNativeAd alloc] initWithAdAdapter:adAdapter];
    
    NSMutableArray *imageURLs = [NSMutableArray array];
    
    if ([[interfaceAd.properties objectForKey:kAdIconImageKey] length]) {
        if (![MPNativeAdUtils addURLString:[interfaceAd.properties objectForKey:kAdIconImageKey] toURLArray:imageURLs]) {
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:MPNativeAdNSErrorForInvalidImageURL()];
        }
    }
    
    if ([[interfaceAd.properties objectForKey:kAdMainImageKey] length]) {
        if (![MPNativeAdUtils addURLString:[interfaceAd.properties objectForKey:kAdMainImageKey] toURLArray:imageURLs]) {
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:MPNativeAdNSErrorForInvalidImageURL()];
        }
    }
    
    [super precacheImagesWithURLs:imageURLs completionBlock:^(NSArray *errors) {
        if (errors) {
            MPLogDebug(@"%@", errors);
            [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:MPNativeAdNSErrorForImageDownloadFailure()];
        } else {
            [self.delegate nativeCustomEvent:self didLoadAd:interfaceAd];
        }
    }];    
}

- (void)nativeAd:(TSNativeAd *)nativeAd didFailWithError:(NSError *)error {
    if (error.code == TSErrorNoFill) {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:MPNativeAdNSErrorForNoInventory()];
    } else {
        [self.delegate nativeCustomEvent:self didFailToLoadAdWithError:MPNativeAdNSErrorForInvalidAdServerResponse(@"TapSense ad load error")];
    }
}



@end
