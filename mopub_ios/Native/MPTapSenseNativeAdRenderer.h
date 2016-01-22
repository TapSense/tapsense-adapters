//
//  MPTapSenseNativeAdRender.h
//  TapSense
//
//  Copyright (c) 2015 TapSense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPNativeAdRenderer.h"

/**
 * Renderer class that supports MPTapSenseNativeCustomEvent
 */

@interface MPTapSenseNativeAdRenderer : NSObject <MPNativeAdRenderer>

@property (nonatomic, readonly) MPNativeViewSizeHandler viewSizeHandler;

@end
