//
//  TSBanner.h
//  Copyright (c) 2014 TapSense. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TSAdInstance.h"
#import "TSBannerDelegate.h"

@interface TSBanner : NSObject

@property (nonatomic, weak) id <TSBannerDelegate> delegate;
@property (nonatomic, strong) TSAdInstance *adInstance;
@property (nonatomic, strong) UIViewController *rootViewController;

- (void) requestBannerWithSize:(CGSize)size;

@end
