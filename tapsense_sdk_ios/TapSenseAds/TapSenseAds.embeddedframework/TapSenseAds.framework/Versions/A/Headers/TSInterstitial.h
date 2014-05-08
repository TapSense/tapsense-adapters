//
//  TSInterstitial.h
//  Copyright (c) 2014 TapSense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TSInterstitialDelegate.h"
#import "TSAdInstance.h"

@interface TSInterstitial : NSObject

@property (nonatomic, weak) id <TSInterstitialDelegate> delegate;
@property (nonatomic, strong) TSAdInstance *adInstance;

- (void) requestInterstitial;
- (void) showInterstitialFromViewController: (UIViewController *) viewController;

@end
