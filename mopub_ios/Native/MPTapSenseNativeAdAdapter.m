//
//  MPTapSenseNativeAdAdapter.m
//  TapSense
//
//  Copyright (c) 2015 TapSense. All rights reserved.
//

#import <TapSenseAds/TSNativeAd.h>
#import "MPTapSenseNativeAdAdapter.h"
#import "MPNativeAdError.h"
#import "MPNativeAdConstants.h"
#import "MPAdDestinationDisplayAgent.h"
#import "MPCoreInstanceProvider.h"
#import "MPLogging.h"
#import "MPStaticNativeAdImpressionTimer.h"

static const NSTimeInterval kTapSenseRequiredSecondsForImpression = 0.0;
static const CGFloat kTapSenseRequiredViewVisibilityPercentage = 0.5;

@interface MPTapSenseNativeAdAdapter() <MPAdDestinationDisplayAgentDelegate, MPStaticNativeAdImpressionTimerDelegate>

@property (nonatomic, readonly, strong) TSNativeAd *tsNativeAd;
@property (nonatomic) MPStaticNativeAdImpressionTimer *impressionTimer;
@property (nonatomic, readonly, strong) MPAdDestinationDisplayAgent *destinationDisplayAgent;

@end

@implementation MPTapSenseNativeAdAdapter

@synthesize properties = _properties;

- (instancetype)initWithTapSenseNativeAd:(TSNativeAd *)nativeAd
{
    self = [super init];
    if (self) {
        _tsNativeAd = nativeAd;
        NSMutableDictionary *properties = [NSMutableDictionary dictionary];
        
        if (nativeAd.title){
            [properties setObject:nativeAd.title forKey:kAdTitleKey];
        }
        if (nativeAd.text){
            [properties setObject:nativeAd.text forKey:kAdTextKey];
        }
        
        if (nativeAd.ctaText){
            [properties setObject:nativeAd.ctaText forKey:kAdCTATextKey];
        }

        if (nativeAd.image){
            [properties setObject:nativeAd.image forKey:kAdMainImageKey];
        }

        if (nativeAd.icon){
            [properties setObject:nativeAd.icon forKey:kAdIconImageKey];
        }
        
        if (nativeAd.starRating){
            [properties setObject:nativeAd.starRating forKey:kAdStarRatingKey];
        }
        
        _properties = properties;
        _destinationDisplayAgent = [[MPCoreInstanceProvider sharedProvider] buildMPAdDestinationDisplayAgentWithDelegate:self];

        _impressionTimer = [[MPStaticNativeAdImpressionTimer alloc] initWithRequiredSecondsForImpression:kTapSenseRequiredSecondsForImpression requiredViewVisibilityPercentage:kTapSenseRequiredViewVisibilityPercentage];
        _impressionTimer.delegate = self;
    }
    
    return self;
}

- (NSURL *) defaultActionURL {
    return [NSURL URLWithString:[self.tsNativeAd clickUrl]];
}

- (void)dealloc
{
    [_destinationDisplayAgent cancel];
    [_destinationDisplayAgent setDelegate:nil];
}

#pragma mark - MPNativeAdAdapter

- (void)willAttachToView:(UIView *)view
{
    [self.impressionTimer startTrackingView:view];
}

- (void) trackImpression {
    [self.tsNativeAd sendImpression];
    [self.delegate nativeAdWillLogImpression:self];
}

- (void)displayContentForURL:(NSURL *)URL rootViewController:(UIViewController *)controller
{
    if (!controller) {
        return;
    }

    if (!URL || ![URL isKindOfClass:[NSURL class]] || ![URL.absoluteString length]) {
        return;
    }

    [self.destinationDisplayAgent displayDestinationForURL:URL];
}

#pragma mark - <MPAdDestinationDisplayAgentDelegate>

- (UIViewController *)viewControllerForPresentingModalView
{
    return [self.delegate viewControllerForPresentingModalView];
}

- (void)displayAgentWillPresentModal
{
    [self.delegate nativeAdWillPresentModalForAdapter:self];
}

- (void)displayAgentWillLeaveApplication
{
    [self.delegate nativeAdWillLeaveApplicationFromAdapter:self];
}

- (void)displayAgentDidDismissModal
{
    [self.delegate nativeAdDidDismissModalForAdapter:self];
}

@end
