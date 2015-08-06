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

@interface MPTapSenseNativeAdAdapter() <MPAdDestinationDisplayAgentDelegate>

@property (nonatomic, readonly, strong) TSNativeAd *tsNativeAd;

@property (nonatomic, readonly, strong) MPAdDestinationDisplayAgent *destinationDisplayAgent;
@property (nonatomic, weak) UIViewController *rootViewController;
@property (nonatomic, copy) void (^actionCompletionBlock)(BOOL, NSError *);

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
    }
    
    return self;
}

- (NSURL *) defaultActionURL {
    return [NSURL URLWithString:[self.tsNativeAd clickUrl]];
}

- (void) trackImpression {
    [self.tsNativeAd sendImpression];
}

- (void)dealloc
{
    [_destinationDisplayAgent cancel];
    [_destinationDisplayAgent setDelegate:nil];
}

#pragma mark - MPNativeAdAdapter

- (NSTimeInterval)requiredSecondsForImpression
{
    return 0.0;
}

- (void)displayContentForURL:(NSURL *)URL rootViewController:(UIViewController *)controller
                  completion:(void (^)(BOOL success, NSError *error))completionBlock
{
    NSError *error = nil;

    if (!controller) {
        error = MPNativeAdNSErrorForContentDisplayErrorMissingRootController();
    }

    if (!URL || ![URL isKindOfClass:[NSURL class]] || ![URL.absoluteString length]) {
        error = MPNativeAdNSErrorForContentDisplayErrorInvalidURL();
    }

    if (error) {

        if (completionBlock) {
            completionBlock(NO, error);
        }
        return;
    }

    self.rootViewController = controller;
    self.actionCompletionBlock = completionBlock;

    [self.destinationDisplayAgent displayDestinationForURL:URL];
}

#pragma mark - <MPAdDestinationDisplayAgent>

- (UIViewController *)viewControllerForPresentingModalView
{
    return self.rootViewController;
}

- (void)displayAgentWillPresentModal
{
    //DO NOT remove this. This will cause MoPub SDK to crash.
}

- (void)displayAgentWillLeaveApplication
{
    if (self.actionCompletionBlock) {
        self.actionCompletionBlock(YES, nil);
        self.actionCompletionBlock = nil;
    }
}

- (void)displayAgentDidDismissModal
{
    if (self.actionCompletionBlock) {
        self.actionCompletionBlock(YES, nil);
        self.actionCompletionBlock = nil;
    }
    self.rootViewController = nil;
}


@end
