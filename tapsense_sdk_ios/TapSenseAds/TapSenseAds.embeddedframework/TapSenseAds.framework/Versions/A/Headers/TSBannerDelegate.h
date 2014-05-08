//
//  TSBannerDelegate.h
//  Copyright (c) 2014 TapSense. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TSBannerDelegate <NSObject>

- (void) bannerDidLoadAdView:(UIView *)view;
- (void) bannerDidFailToLoadAdWithError:(NSError*)error;
- (void) bannerWillShowModal;
- (void) bannerDidDismissModal;
- (void) bannerWillLeaveApplication;

@end
