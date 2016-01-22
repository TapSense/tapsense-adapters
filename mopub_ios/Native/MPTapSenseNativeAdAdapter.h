//
//  MPTapSenseNativeAdAdapter.h
//  TapSense
//
//  Copyright (c) 2015 TapSense. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#else
    #import "MPNativeAdAdapter.h"
#endif

@class TSNativeAd;

/*
 * Certified with version 3.1.0 of TapSense SDK amnd MoPub SDK 4.0+.
 */

@interface MPTapSenseNativeAdAdapter : NSObject <MPNativeAdAdapter>

@property (nonatomic, weak) id<MPNativeAdAdapterDelegate> delegate;

- (instancetype)initWithTapSenseNativeAd:(TSNativeAd *)nativeAd;

@end
