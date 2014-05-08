//
//  TSInterstitialDelegate.h
//  Copyright (c) 2014 TapSense. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TSInterstitialDelegate <NSObject>

- (void) interstitialDidLoad;
- (void) interstitialDidFailToLoadAdWithError:(NSError*)error;
- (void) interstitialWillAppear;
- (void) interstitialDidDisappear;

@end
